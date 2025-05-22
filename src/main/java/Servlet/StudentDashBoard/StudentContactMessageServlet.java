package Servlet.StudentDashBoard;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.ContactMessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ContactMessage;
import model.User;

@WebServlet("/student/contact")
public class StudentContactMessageServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentContactMessageServlet.class.getName());
    private ContactMessageDAO contactMessageDAO;

    @Override
    public void init() throws ServletException {
        contactMessageDAO = new ContactMessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
            return;
        }

        // Display the contact form page
        request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentContactMessage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");

        if (title == null || title.trim().isEmpty() || description == null || description.trim().isEmpty()) {
            request.setAttribute("error", "Title and description are required.");
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentContactMessage.jsp").forward(request, response);
            return;
        }

        ContactMessage message = new ContactMessage();
        message.setUserId(user.getId());
        message.setTitle(title);
        message.setDescription(description);
        message.setCreatedAt(new Date()); // Set current date/time

        try {
            boolean success = contactMessageDAO.saveMessage(message);
            if (success) {
                request.setAttribute("success", "Your message has been sent.");
            } else {
                request.setAttribute("error", "Failed to send message. Please try again.");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error saving contact message", e);
            request.setAttribute("error", "An error occurred while sending your message. Please try again later.");
        }

        request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentContactMessage.jsp").forward(request, response);
    }
} 