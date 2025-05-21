<%--
  Created by IntelliJ IDEA.
  User: Dell
  Date: 5/16/2025
  Time: 12:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, model.Teacher, model.Student, dao.TeacherDAO, dao.StudentDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>

<%
    // Session check
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login?error=unauthenticated");
        return;
    }

    // Get data from request attributes
    List<Student> students = (List<Student>) request.getAttribute("students");
    List<Teacher> teachers = (List<Teacher>) request.getAttribute("teachers");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4a90e2;
            --secondary-color: #f5f6fa;
            --accent-color: #2ecc71;
            --text-color: #2c3e50;
            --danger-color: #e74c3c;
            --warning-color: #f1c40f;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--secondary-color);
            color: var(--text-color);
        }

        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            color: var(--primary-color) !important;
            font-weight: bold;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #357abd;
            transform: translateY(-2px);
        }

        .table {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .table th {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }

        .table td {
            vertical-align: middle;
        }

        .actions {
            white-space: nowrap;
        }

        .btn-warning {
            background-color: var(--warning-color);
            border: none;
            color: white;
        }

        .btn-danger {
            background-color: var(--danger-color);
            border: none;
        }

        .btn i {
            margin-right: 5px;
        }

        .search-box {
            position: relative;
            margin-bottom: 20px;
        }

        .search-box input {
            padding-left: 40px;
            border-radius: 20px;
            border: 1px solid #ddd;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }

        .filter-section {
            margin-bottom: 20px;
        }

        .filter-section select {
            border-radius: 20px;
            padding: 8px 15px;
            border: 1px solid #ddd;
        }

        .alert {
            border-radius: 10px;
            border: none;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users"></i> Users
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/notifications">
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

    <!-- Main Content -->
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="card-title">
                                <i class="fas fa-users"></i> User Management
                            </h2>
                        </div>

                        <!-- Search and Filter -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="search-box">
                                    <i class="fas fa-search"></i>
                                    <input type="text" class="form-control" id="searchInput" placeholder="Search users...">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="filter-section">
                                    <select class="form-select" id="roleFilter">
                                        <option value="all">All Roles</option>
                                        <option value="student">Students</option>
                                        <option value="teacher">Teachers</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Alerts -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Students Table -->
                        <h3 class="mb-3" id="students-section">Students</h3>
                        <div class="table-responsive" id="students-table">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Roll No</th>
                                        <th>Class</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${students}" var="student">
                                        <tr>
                                            <td>${student.username}</td>
                                            <td>${student.email}</td>
                                            <td>${student.rollNumber}</td>
                                            <td>${student.className}</td>
                                            <td class="actions">
                                                <form action="${pageContext.request.contextPath}/admin/users/delete" method="post" class="d-inline" onsubmit="return handleDelete(this, 'student')">
                                                    <input type="hidden" name="id" value="${student.id}">
                                                    <input type="hidden" name="role" value="student">
                                                    <button type="submit" class="btn btn-danger">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Teachers Table -->
                        <h3 class="mb-3 mt-4" id="teachers-section">Teachers</h3>
                        <div class="table-responsive" id="teachers-table">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Employee ID</th>
                                        <th>Department</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${teachers}" var="teacher">
                                        <tr>
                                            <td>${teacher.username}</td>
                                            <td>${teacher.email}</td>
                                            <td>${teacher.employeeId}</td>
                                            <td>${teacher.department}</td>
                                            <td class="actions">
                                                <form action="${pageContext.request.contextPath}/admin/users/delete" method="post" class="d-inline" onsubmit="return handleDelete(this, 'teacher')">
                                                    <input type="hidden" name="id" value="${teacher.id}">
                                                    <input type="hidden" name="role" value="teacher">
                                                    <button type="submit" class="btn btn-danger">
                                                        <i class="fas fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        // Initialize AOS
        AOS.init();

        // Handle delete operation
        function handleDelete(form, role) {
            const userId = form.querySelector('input[name="id"]').value;
            const username = form.closest('tr').querySelector('td:first-child').textContent;
            
            if (confirm(`Are you sure you want to delete this ${role} (${username})?`)) {
                const button = form.querySelector('button');
                const originalText = button.innerHTML;
                
                // Disable button and show loading state
                button.disabled = true;
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';
                
                // Submit the form
                form.submit();
                return true;
            }
            return false;
        }

        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const searchText = this.value.toLowerCase();
            const tables = document.querySelectorAll('table');
            
            tables.forEach(table => {
                const rows = table.getElementsByTagName('tr');
                for (let i = 1; i < rows.length; i++) {
                    const row = rows[i];
                    const cells = row.getElementsByTagName('td');
                    let found = false;
                    
                    for (let j = 0; j < cells.length; j++) {
                        const cell = cells[j];
                        if (cell.textContent.toLowerCase().indexOf(searchText) > -1) {
                            found = true;
                            break;
                        }
                    }
                    
                    row.style.display = found ? '' : 'none';
                }
            });
        });

        // Role filter functionality
        document.getElementById('roleFilter').addEventListener('change', function() {
            const selectedRole = this.value;
            const studentsSection = document.getElementById('students-section');
            const teachersSection = document.getElementById('teachers-section');
            const studentsTable = document.getElementById('students-table');
            const teachersTable = document.getElementById('teachers-table');
            
            if (selectedRole === 'all') {
                studentsSection.style.display = '';
                teachersSection.style.display = '';
                studentsTable.style.display = '';
                teachersTable.style.display = '';
            } else if (selectedRole === 'student') {
                studentsSection.style.display = '';
                teachersSection.style.display = 'none';
                studentsTable.style.display = '';
                teachersTable.style.display = 'none';
            } else if (selectedRole === 'teacher') {
                studentsSection.style.display = 'none';
                teachersSection.style.display = '';
                studentsTable.style.display = 'none';
                teachersTable.style.display = '';
            }
        });
    </script>
</body>
</html>
