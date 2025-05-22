package Servlet.StudentDashBoard;

import java.io.IOException;
import java.util.List;

import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import model.User;

@WebServlet("/student/notifications/*")
public class StudentNotificationsServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");

    // Check if user is logged in and is a student
    if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect(request.getContextPath() + "/login?error=unauthenticated");
      return;
    }

    String pathInfo = request.getPathInfo();
    if (pathInfo == null || pathInfo.equals("/")) {
      // Show notifications page
      showNotificationsPage(request, response);
    } else if (pathInfo.equals("/mark-read")) {
      // Mark notification as read
      markNotificationAsRead(request, response);
    } else {
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
  }

  private void showNotificationsPage(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      StudentDAO dao = new StudentDAO();
      List<Notification> notifications = dao.getStudentNotifications();
      request.setAttribute("notifications", notifications);
      request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentNotifications.jsp")
          .forward(request, response);
    } catch (Exception e) {
      e.printStackTrace();
      response.sendRedirect(request.getContextPath() + "/student-dash?error=notification_error");
    }
  }

  private void markNotificationAsRead(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String notificationId = request.getParameter("id");
    if (notificationId != null && !notificationId.isEmpty()) {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": true}");
    } else {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"error\": \"Invalid notification ID\"}");
    }
  }
}