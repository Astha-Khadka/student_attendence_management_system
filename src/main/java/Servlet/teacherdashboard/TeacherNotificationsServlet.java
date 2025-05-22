package Servlet.teacherdashboard;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.ContactMessageDAO;
import dao.NotificationDAO;
import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ContactMessage;
import model.Notification;
import model.User;

@WebServlet("/teacher/notifications")
public class TeacherNotificationsServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");

    // Check if user is logged in and is a teacher
    if (user == null || !"teacher".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
      return;
    }

    showNotificationsPage(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String action = request.getParameter("action");
    if ("create".equals(action)) {
      createNotification(request, response);
    } else if ("delete".equals(action)) {
      deleteNotification(request, response);
    } else if ("respond".equals(action)) {
      respondToContactMessage(request, response);
    } else {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  private void showNotificationsPage(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      NotificationDAO notificationDAO = new NotificationDAO();
      ContactMessageDAO contactMessageDAO = new ContactMessageDAO();
      
      // Get notifications for the teacher
      List<Notification> notifications = notificationDAO.getNotificationsForUser(((User) request.getSession().getAttribute("user")).getId());
      
      // Get contact messages
      List<ContactMessage> contactMessages = contactMessageDAO.getAllContactMessages();
      
      request.setAttribute("notifications", notifications);
      request.setAttribute("contactMessages", contactMessages);
      request.getRequestDispatcher("/WEB-INF/view/users_dashboards/teacher_dashboard/notifications.jsp")
              .forward(request, response);
    } catch (Exception e) {
      e.printStackTrace();
      response.sendRedirect(request.getContextPath() + "/Nav_teacher_dashServlet?error=notification_error");
    }
  }

  private void createNotification(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      String type = request.getParameter("type");
      String title = request.getParameter("title");
      String message = request.getParameter("message");
      Notification notif = new Notification();
      notif.setType(type);
      notif.setTitle(title);
      notif.setMessage(message);
      notif.setRead(false);
      NotificationDAO dao = new NotificationDAO();
      dao.addNotification(notif);
      response.sendRedirect(request.getContextPath() + "/teacher/notifications");
    } catch (SQLException e) {
      e.printStackTrace();
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  private void deleteNotification(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      int notificationId = Integer.parseInt(request.getParameter("id"));
      NotificationDAO dao = new NotificationDAO();
      dao.deleteNotification(notificationId);
      response.sendRedirect(request.getContextPath() + "/teacher/notifications");
    } catch (Exception e) {
      e.printStackTrace();
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  private void respondToContactMessage(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      int messageId = Integer.parseInt(request.getParameter("messageId"));
      String responseText = request.getParameter("response");
      
      // Get the original message
      ContactMessageDAO contactMessageDAO = new ContactMessageDAO();
      ContactMessage originalMessage = contactMessageDAO.getContactMessageById(messageId);
      
      if (originalMessage != null) {
        // Create a notification for the student
        Notification responseNotification = new Notification();
        responseNotification.setUserId(originalMessage.getUserId());
        responseNotification.setType("contact_response");
        responseNotification.setTitle("Response to your message: " + originalMessage.getTitle());
        responseNotification.setMessage(responseText);
        responseNotification.setRead(false);
        
        NotificationDAO notificationDAO = new NotificationDAO();
        notificationDAO.addNotification(responseNotification);
      }
      
      response.sendRedirect(request.getContextPath() + "/teacher/notifications");
    } catch (Exception e) {
      e.printStackTrace();
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
  }
}