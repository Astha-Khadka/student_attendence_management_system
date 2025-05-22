<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, model.User, model.Notification, dao.StudentDAO, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Notifications</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/favicon.png">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            padding: 0;
            line-height: 1.6;
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #4682b4, #b0c4de);
            color: #fff;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            padding: 20px;
            z-index: 1000;
            transition: width 0.3s ease, transform 0.3s ease;
            overflow-y: auto;
        }

        .sidebar.collapsed {
            width: 60px;
        }

        .sidebar.collapsed .logo,
        .sidebar.collapsed .nav-text {
            display: none;
        }

        .sidebar.active {
            transform: translateX(0);
        }

        .sidebar .logo {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }

        .sidebar .toggle-btn {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .sidebar .toggle-btn i {
            font-size: 24px;
            cursor: pointer;
            color: #fff;
            transition: transform 0.3s ease;
        }

        .sidebar .toggle-btn i:hover {
            transform: scale(1.2);
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #fff;
            padding: 12px 16px;
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 8px;
            font-size: 16px;
            transition: background 0.3s ease;
        }

        .sidebar a:hover {
            background-color: #f4a261;
            color: #2f4f4f;
        }

        .sidebar.collapsed a {
            justify-content: center;
            padding: 12px;
        }

        .sidebar-toggle {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            font-size: 24px;
            color: #4682b4;
            cursor: pointer;
            z-index: 1100;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
            flex: 1;
            transition: margin-left 0.3s ease;
            padding-bottom: 60px;
        }

        .sidebar.collapsed ~ .main-content {
            margin-left: 60px;
        }

        .container {
            max-width: 1000px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .notification-card {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .notification-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .notification-card h3 {
            font-size: 1.3rem;
            color: #4682b4;
            margin-bottom: 0.8rem;
        }

        .notification-card p {
            font-size: 1rem;
            color: #4B5563;
            margin-bottom: 1rem;
        }

        .notification-card .timestamp {
            font-size: 0.9rem;
            color: #999;
            text-align: right;
        }

        .no-notifications {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .no-notifications i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #999;
        }

        .error-message {
            background: linear-gradient(90deg, #f8d7da, #f5f5f5);
            border-left: 5px solid #dc3545;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 16px;
            color: #721c24;
            margin: 16px 0;
        }

        footer {
            background-color: #2f4f4f;
            padding: 32px 16px;
            color: #fff;
            text-align: center;
            width: 100%;
            position: relative;
            margin-top: auto;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 250px;
                transform: translateX(-250px);
            }

            .sidebar.active {
                transform: translateX(0);
            }

            .sidebar.collapsed {
                width: 250px;
                transform: translateX(-250px);
            }

            .sidebar-toggle {
                display: block;
            }

            .main-content {
                margin-left: 0;
                padding: 15px;
                padding-bottom: 60px;
            }

            .sidebar.collapsed ~ .main-content {
                margin-left: 0;
            }

            .notification-card {
                padding: 1rem;
            }

            .notification-card h3 {
                font-size: 1.1rem;
            }

            .notification-card p {
                font-size: 0.9rem;
            }

            .notification-card .timestamp {
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>

<% 
    User user = (User) session.getAttribute("user");
    if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
        return;
    }

    List<Notification> notifications = null;
    String error = null;
    try {
        StudentDAO studentDAO = new StudentDAO();
        notifications = studentDAO.getStudentNotifications(); // Assuming this fetches relevant notifications
    } catch (SQLException e) {
        error = "Error loading notifications. Please try again later.";
        e.printStackTrace(); // Log the error for debugging
    }
%>

<aside class="sidebar" id="sidebar">
    <div class="toggle-btn" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </div>
    <div class="logo">Itahari International</div>
    <a href="${pageContext.request.contextPath}/student-dash" title="Go to Dashboard"><i class="fas fa-home"></i><span class="nav-text">Dashboard</span></a>
    <a href="${pageContext.request.contextPath}/student-attendance" title="View Attendance"><i class="fas fa-clipboard-check"></i><span class="nav-text">Attendance</span></a>
    <a href="${pageContext.request.contextPath}/student/notifications" title="View Notifications"><i class="fas fa-bell"></i><span class="nav-text">Notifications</span></a>
    <a href="${pageContext.request.contextPath}/student/contact">
        <i class="fas fa-envelope"></i>
        <span class="nav-text">Contact Teacher</span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" title="Log Out"><i class="fas fa-sign-out-alt"></i><span class="nav-text">Logout</span></a>
</aside>

<div class="sidebar-toggle" id="sidebar-toggle">
    <i class="fas fa-bars"></i>
</div>

<div class="main-content">
    <div class="container">
        <h2 style="font-size: 2rem; color: #2f4f4f; margin-bottom: 1.5rem;"><i class="fas fa-bell"></i> Your Notifications</h2>

        <% if (error != null) { %>
            <div class="error-message"><%= error %></div>
        <% } else if (notifications != null && !notifications.isEmpty()) { %>
            <% for (Notification notification : notifications) { %>
                <div class="notification-card">
                    <h3><%= notification.getTitle() != null ? notification.getTitle() : "No Title" %></h3>
                    <p><%= notification.getMessage() != null ? notification.getMessage() : "No message content." %></p>
                    <div class="timestamp">
                        <%= notification.getCreatedAt() != null ? new SimpleDateFormat("yyyy-MM-dd HH:mm").format(notification.getCreatedAt()) : "N/A" %>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="no-notifications">
                <i class="fas fa-info-circle"></i>
                <p>You have no new notifications.</p>
            </div>
        <% } %>
    </div>

    <footer>
        <div style="max-width: 1200px; margin: 0 auto;">
            <p style="font-size: 16px;">© <%= new java.util.Date().getYear() + 1900 %> Itahari International College. All rights reserved.</p>
        </div>
    </footer>
</div>

<script>
    const sidebar = document.getElementById('sidebar');
    const toggle = document.getElementById('sidebar-toggle');

    function toggleSidebar() {
        sidebar.classList.toggle('collapsed');
    }

    toggle.addEventListener('click', () => {
        sidebar.classList.toggle('active');
        sidebar.classList.toggle('collapsed');
        if (sidebar.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }
    });

    document.addEventListener('click', (event) => {
        if (!sidebar.contains(event.target) && !toggle.contains(event.target) && sidebar.classList.contains('active')) {
            sidebar.classList.remove('active');
            document.body.style.overflow = '';
        }
    });

    window.addEventListener('resize', () => {
        if (window.innerWidth > 768) {
            sidebar.classList.remove('active');
            document.body.style.overflow = '';
        } else {
            sidebar.classList.remove('collapsed');
        }
    });

    window.addEventListener('load', () => {
        if (window.innerWidth <= 768) {
            sidebar.classList.add('collapsed');
        }
    });
</script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ duration: 1000 });
</script>

</body>
</html> 