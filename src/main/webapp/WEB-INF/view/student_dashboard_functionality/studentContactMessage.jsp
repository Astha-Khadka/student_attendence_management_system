<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Teacher</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 var(--spacing);
        }

        .contact-form {
            background: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--card-shadow);
        }

        .form-header {
            margin-bottom: 2rem;
            text-align: center;
        }

        .form-header h2 {
            color: var(--text-color);
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: #666;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-color);
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(70, 130, 180, 0.1);
        }

        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }

        .btn-submit {
            background-color: #4682b4;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.3s ease;
            width: 100%;
        }

        .btn-submit:hover {
            background-color: #357abd;
            color: white;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
            }

            .sidebar.collapsed ~ .main-content {
                margin-left: 0;
            }

            .container {
                padding: 0 1rem;
            }

            .contact-form {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>

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
        <div class="contact-form">
            <div class="form-header">
                <h2><i class="fas fa-envelope"></i> Contact Teacher</h2>
                <p>Send a message to the administrator</p>
            </div>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/student/contact" method="post">
                <div class="form-group">
                    <label for="title" class="form-label">Title</label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" required></textarea>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-paper-plane"></i> Send Message
                </button>
            </form>
        </div>
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

</body>
</html> 