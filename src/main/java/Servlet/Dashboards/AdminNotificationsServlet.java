package Servlet.Dashboards;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/admin/notifications/*")
public class AdminNotificationsServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");

    // Check if user is logged in and is an admin
    if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
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
    } else if (pathInfo.equals("/action")) {
      // Handle notification action
      handleNotificationAction(request, response);
    } else {
      response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    String action = request.getParameter("action");
    if ("create".equals(action)) {
      createNotification(request, response);
    } else if ("delete".equals(action)) {
      deleteNotification(request, response);
    } else {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  private void showNotificationsPage(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      // Load notifications
      List<Map<String, Object>> notifications = loadNotifications();
      request.setAttribute("notifications", notifications);

      request.getRequestDispatcher("/WEB-INF/view/users_dashboards/admin_dashboard/notifications.jsp")
          .forward(request, response);
    } catch (Exception e) {
      e.printStackTrace();
      response.sendRedirect(request.getContextPath() + "/admin?error=notification_error");
    }
  }

  private void markNotificationAsRead(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String notificationId = request.getParameter("id");
    if (notificationId != null && !notificationId.isEmpty()) {
      // TODO: Implement marking notification as read in database
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": true}");
    } else {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"error\": \"Invalid notification ID\"}");
    }
  }

  private void handleNotificationAction(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String notificationId = request.getParameter("id");
    String action = request.getParameter("action");

    if (notificationId != null && !notificationId.isEmpty() && action != null && !action.isEmpty()) {
      // TODO: Implement notification action handling
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": true}");
    } else {
      response.setContentType("application/json");
      response.getWriter().write("{\"success\": false, \"error\": \"Invalid parameters\"}");
    }
  }

  private void createNotification(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      String message = request.getParameter("message");
      String type = request.getParameter("type");
      // TODO: Implement saving notification to database
      response.sendRedirect(request.getContextPath() + "/admin/notifications");
    } catch (Exception e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  private void deleteNotification(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      String notificationId = request.getParameter("id");
      // TODO: Implement deleting notification from database
      response.sendRedirect(request.getContextPath() + "/admin/notifications");
    } catch (Exception e) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }
  }

  private List<Map<String, Object>> loadNotifications() {
    // TODO: Implement loading notifications from database
    // For now, return mock data
    List<Map<String, Object>> notifications = new ArrayList<>();

    // Sample attendance notification
    Map<String, Object> attendanceNotification = new HashMap<>();
    attendanceNotification.put("id", "1");
    attendanceNotification.put("type", "attendance");
    attendanceNotification.put("title", "Low Attendance Alert");
    attendanceNotification.put("message", "Class BCA-3 has attendance below 75% for the past week");
    attendanceNotification.put("time", "2 hours ago");
    attendanceNotification.put("actionable", true);
    attendanceNotification.put("actionText", "View Details");
    notifications.add(attendanceNotification);

    // Sample user management notification
    Map<String, Object> userNotification = new HashMap<>();
    userNotification.put("id", "2");
    userNotification.put("type", "user");
    userNotification.put("title", "New Teacher Registration");
    userNotification.put("message", "A new teacher has registered and is pending approval");
    userNotification.put("time", "5 hours ago");
    userNotification.put("actionable", true);
    userNotification.put("actionText", "Review");
    notifications.add(userNotification);

    // Sample system notification
    Map<String, Object> systemNotification = new HashMap<>();
    systemNotification.put("id", "3");
    systemNotification.put("type", "system");
    systemNotification.put("title", "System Maintenance");
    systemNotification.put("message", "Scheduled maintenance will occur tonight at 2 AM");
    systemNotification.put("time", "1 day ago");
    systemNotification.put("actionable", false);
    notifications.add(systemNotification);

    return notifications;
  }
}