<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*, model.*" %>

<%
    // Session check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthenticated");
        return;
    }

    // Get notifications from request attributes
    List<Map<String, Object>> notifications = (List<Map<String, Object>>) request.getAttribute("notifications");
    if (notifications == null) {
        notifications = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            line-height: 1.6;
            background-color: #f5f5f5;
        }
        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .navbar-brand {
            color: #4a90e2 !important;
            font-weight: bold;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
        }

        .card {
            background-color: #fff;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .notification {
            padding: 16px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: flex-start;
            gap: 16px;
        }

        .notification:last-child {
            border-bottom: none;
        }

        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            flex-shrink: 0;
        }

        .notification-icon.attendance {
            background-color: #4CAF50;
        }

        .notification-icon.user {
            background-color: #2196F3;
        }

        .notification-icon.system {
            background-color: #FF9800;
        }

        .notification-icon.default {
            background-color: #9E9E9E;
        }

        .notification-content {
            flex-grow: 1;
        }

        .notification-title {
            font-weight: bold;
            margin-bottom: 4px;
            color: #1e90ff;
        }

        .notification-message {
            color: #4B5563;
            margin-bottom: 8px;
        }

        .notification-time {
            font-size: 12px;
            color: #666;
        }

        .notification-actions {
            display: flex;
            gap: 8px;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            border: none;
            background-color: #1e90ff;
            color: #fff;
        }

        .btn-secondary {
            background-color: #e5e7eb;
            color: #4B5563;
        }

        .notification-filters {
            display: flex;
            gap: 16px;
            margin-bottom: 24px;
        }

        .filter-btn {
            padding: 8px 16px;
            border-radius: 4px;
            border: 1px solid #ddd;
            background-color: #fff;
            color: #4B5563;
            cursor: pointer;
        }

        .filter-btn.active {
            background-color: #1e90ff;
            color: #fff;
            border-color: #1e90ff;
        }

        .inline-form {
            display: inline;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin">
                <i class="fas fa-graduation-cap"></i> Admin Dashboard
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users"></i> Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/notifications">
                            <i class="fas fa-bell"></i> Notifications
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/settings">
                            <i class="fas fa-cog"></i> Settings
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Notification Filters -->
        <div class="notification-filters" data-aos="fade-up">
            <button class="filter-btn active" data-filter="all">All</button>
            <button class="filter-btn" data-filter="attendance">Attendance</button>
            <button class="filter-btn" data-filter="user">User Management</button>
            <button class="filter-btn" data-filter="system">System</button>
        </div>

        <!-- Notifications List -->
        <div class="card" data-aos="fade-up" data-aos-delay="200">
            <h2 style="color: #1e90ff; margin-bottom: 16px;"><i class="fas fa-bell"></i> Notifications</h2>
            
            <c:if test="${empty notifications}">
                <p style="text-align: center; color: #666;">No notifications to display</p>
            </c:if>
            
            <c:forEach items="${notifications}" var="notification">
                <div class="notification" data-type="${notification.type}">
                    <div class="notification-icon ${notification.type}">
                        <i class="fas ${notification.icon}"></i>
                    </div>
                    <div class="notification-content">
                        <div class="notification-title">${notification.title}</div>
                        <div class="notification-message">${notification.message}</div>
                        <div class="notification-time">${notification.time}</div>
                    </div>
                    <div class="notification-actions">
                        <c:if test="${notification.actionable}">
                            <form class="inline-form" action="${pageContext.request.contextPath}/admin/notifications/action" method="post">
                                <input type="hidden" name="id" value="${notification.id}">
                                <button type="submit" class="btn">${notification.actionText}</button>
                            </form>
                        </c:if>
                        <form class="inline-form" action="${pageContext.request.contextPath}/admin/notifications/mark-read" method="post">
                            <input type="hidden" name="id" value="${notification.id}">
                            <button type="submit" class="btn btn-secondary">Mark as Read</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init();

        // Filter notifications
        document.querySelectorAll('.filter-btn').forEach(button => {
            button.addEventListener('click', () => {
                // Update active state
                document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
                button.classList.add('active');

                // Filter notifications
                const filter = button.dataset.filter;
                document.querySelectorAll('.notification').forEach(notification => {
                    if (filter === 'all' || notification.dataset.type === filter) {
                        notification.style.display = 'flex';
                    } else {
                        notification.style.display = 'none';
                    }
                });
            });
        });
    </script>
</body>
</html>

<%!
    private String getNotificationColor(Object type) {
        switch ((String) type) {
            case "attendance":
                return "#4CAF50";
            case "user":
                return "#2196F3";
            case "system":
                return "#FF9800";
            default:
                return "#9E9E9E";
        }
    }

    private String getNotificationIcon(Object type) {
        switch ((String) type) {
            case "attendance":
                return "fa-calendar-check";
            case "user":
                return "fa-user";
            case "system":
                return "fa-cog";
            default:
                return "fa-bell";
        }
    }
%> 