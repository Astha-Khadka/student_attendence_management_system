package Servlet.StudentDashBoard;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Attendance;
import model.User;

@WebServlet("/student-attendance")
public class StudentAttendanceServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentAttendanceServlet.class.getName());
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
            return;
        }

        try {
            // Fetch attendance records for the student
            List<Attendance> attendanceRecords = studentDAO.getStudentAttendanceRecords(user.getId());
            
            // Calculate attendance statistics
            int totalClasses = attendanceRecords.size();
            int presentCount = 0;
            for (Attendance record : attendanceRecords) {
                if ("present".equalsIgnoreCase(record.getStatus())) {
                    presentCount++;
                }
            }
            
            double attendancePercentage = totalClasses > 0 ? (presentCount * 100.0 / totalClasses) : 0;

            // Set attributes for the JSP
            request.setAttribute("attendanceRecords", attendanceRecords);
            request.setAttribute("totalClasses", totalClasses);
            request.setAttribute("presentCount", presentCount);
            request.setAttribute("absentCount", totalClasses - presentCount);
            request.setAttribute("attendancePercentage", String.format("%.1f", attendancePercentage));

            // Forward to the attendance view
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentAttendance.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching attendance records", e);
            request.setAttribute("error", "Error loading attendance records. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentAttendance.jsp")
                    .forward(request, response);
        }
    }
} 