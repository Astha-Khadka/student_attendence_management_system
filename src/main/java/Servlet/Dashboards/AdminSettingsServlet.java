package Servlet.Dashboards;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/admin/settings/*")
public class AdminSettingsServlet extends HttpServlet {
  private UserDAO userDAO;

  @Override
  public void init() throws ServletException {
    userDAO = new UserDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");

    // Check if user is logged in and is an admin
    if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect(request.getContextPath() + "/login?error=unauthenticated");
      return;
    }

    // Load settings
    Map<String, Object> settings = loadSettings();
    request.setAttribute("settings", settings);

    request.getRequestDispatcher("/WEB-INF/view/users_dashboards/admin_dashboard/settings.jsp")
        .forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");

    // Check if user is logged in and is an admin
    if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
      response.sendRedirect(request.getContextPath() + "/login?error=unauthenticated");
      return;
    }

    String pathInfo = request.getPathInfo();
    if (pathInfo == null) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }

    try {
      switch (pathInfo) {
        case "/profile":
          updateProfile(request, response, user);
          break;
        case "/password":
          updatePassword(request, response, user);
          break;
        case "/system":
          updateSystemSettings(request, response);
          break;
        default:
          response.sendError(HttpServletResponse.SC_NOT_FOUND);
      }
    } catch (Exception e) {
      e.printStackTrace();
      response.sendRedirect(request.getContextPath() + "/admin/settings?error=update_failed");
    }
  }

  private void updateProfile(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
    String username = request.getParameter("username");
    String email = request.getParameter("email");

    if (username != null && !username.isEmpty() && email != null && !email.isEmpty()) {
      user.setUsername(username);
      user.setEmail(email);

      // TODO: Update user in database
      // userDAO.updateUser(user);

      response.sendRedirect(request.getContextPath() + "/admin/settings?success=profile_updated");
    } else {
      response.sendRedirect(request.getContextPath() + "/admin/settings?error=invalid_input");
    }
  }

  private void updatePassword(HttpServletRequest request, HttpServletResponse response, User user) throws IOException {
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    if (currentPassword != null && newPassword != null && confirmPassword != null &&
        newPassword.equals(confirmPassword)) {

      // TODO: Verify current password and update to new password
      // if (userDAO.verifyPassword(user.getId(), currentPassword)) {
      // userDAO.updatePassword(user.getId(), newPassword);
      // response.sendRedirect(request.getContextPath() +
      // "/admin/settings?success=password_updated");
      // } else {
      // response.sendRedirect(request.getContextPath() +
      // "/admin/settings?error=invalid_password");
      // }

      // For now, just redirect with success
      response.sendRedirect(request.getContextPath() + "/admin/settings?success=password_updated");
    } else {
      response.sendRedirect(request.getContextPath() + "/admin/settings?error=invalid_input");
    }
  }

  private void updateSystemSettings(HttpServletRequest request, HttpServletResponse response) throws IOException {
    boolean emailNotifications = "on".equals(request.getParameter("emailNotifications"));
    boolean attendanceAlerts = "on".equals(request.getParameter("attendanceAlerts"));
    String attendanceThreshold = request.getParameter("attendanceThreshold");

    Map<String, Object> settings = new HashMap<>();
    settings.put("emailNotifications", emailNotifications);
    settings.put("attendanceAlerts", attendanceAlerts);
    settings.put("attendanceThreshold", attendanceThreshold);

    // TODO: Save settings to database or configuration file
    // For now, just redirect with success
    response.sendRedirect(request.getContextPath() + "/admin/settings?success=settings_updated");
  }

  private Map<String, Object> loadSettings() {
    // TODO: Load settings from database or configuration file
    // For now, return default settings
    Map<String, Object> settings = new HashMap<>();
    settings.put("emailNotifications", true);
    settings.put("attendanceAlerts", true);
    settings.put("attendanceThreshold", 75);
    return settings;
  }
}