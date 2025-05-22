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
import model.Notification;
import model.Student;
import model.User;

@WebServlet({ "/student", "/student-dash/*" })
public class StudentDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentDashboardServlet.class.getName());
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
            LOGGER.info("Unauthorized access attempt, redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
            return;
        }

        try {
            // Fetch student data
            Student student = studentDAO.getStudentData(user.getId());
            request.setAttribute("student", student);

            // Fetch attendance records
            List<Attendance> attendanceRecords = studentDAO.getStudentAttendanceRecords(user.getId());
            request.setAttribute("attendanceRecords", attendanceRecords);

            // Fetch notifications
            List<Notification> notifications = studentDAO.getStudentNotifications();
            request.setAttribute("notifications", notifications);

            // Calculate attendance statistics
            int totalClasses = attendanceRecords.size();
            int presentCount = 0;
            for (Attendance record : attendanceRecords) {
                if ("present".equalsIgnoreCase(record.getStatus())) {
                    presentCount++;
                }
            }
            
            double attendancePercentage = totalClasses > 0 ? (presentCount * 100.0 / totalClasses) : 0;

            request.setAttribute("attendancePercentage", String.format("%.1f", attendancePercentage));
            request.setAttribute("totalClasses", totalClasses);
            request.setAttribute("classesAttended", presentCount);

            request.getRequestDispatcher("/WEB-INF/view/users_dashboards/student_dash.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching student data", e);
            request.setAttribute("error", "Error loading student dashboard. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/view/users_dashboards/student_dash.jsp")
                    .forward(request, response);
        }
    }
}