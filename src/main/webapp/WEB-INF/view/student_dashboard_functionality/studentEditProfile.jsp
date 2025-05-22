<%-- 
    Document   : studentEditProfile
    Created on : Oct 26, 2023, 10:41:00 PM
    Author     : Bhair
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Student Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

        .profile-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .profile-photo-container {
            position: relative;
            width: 150px;
            height: 150px;
            margin: 0 auto 1.5rem;
        }
        .profile-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #4a90e2;
        }
        .profile-photo-placeholder {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: #6c757d;
            border: 3px solid #4a90e2;
        }
        .photo-upload-btn {
            position: absolute;
            bottom: 0;
            right: 0;
            background: #4a90e2;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .photo-upload-btn:hover {
            background: #357abd;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-label {
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        .form-control {
            border: 1px solid #e9ecef;
            border-radius: 5px;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #4a90e2;
            box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
        }
        .btn-primary {
            background: #4a90e2;
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background: #357abd;
            transform: translateY(-1px);
        }
        .btn-secondary {
            background: #6c757d;
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }
        .alert {
            border-radius: 5px;
            margin-bottom: 1.5rem;
        }
        #photo-upload {
            display: none;
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
        <div class="profile-container">
            <div class="profile-header">
                <h2><i class="fas fa-user-edit"></i> Edit Profile</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/student-edit-profile" method="post" enctype="multipart/form-data">
                <div class="profile-photo-container">
                    <c:choose>
                        <c:when test="${not empty student.photoPath}">
                            <img src="${pageContext.request.contextPath}/Images/${student.photoPath}" 
                                 alt="Profile Photo" 
                                 class="profile-photo"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <div class="profile-photo-placeholder" style="display: none;">
                                <i class="fas fa-user"></i>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="profile-photo-placeholder">
                                <i class="fas fa-user"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <label for="photo-upload" class="photo-upload-btn">
                        <i class="fas fa-camera"></i>
                    </label>
                    <input type="file" id="photo-upload" name="photo" accept="image/*" onchange="previewImage(this)">
                </div>

                <div class="form-group">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" 
                           value="${student.username}" required>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" 
                           value="${student.email}" required>
                </div>

                <div class="form-group">
                    <label for="className" class="form-label">Class Name</label>
                    <input type="text" class="form-control" id="className" name="className" 
                           value="${student.className}" required>
                </div>

                <div class="form-group">
                    <label for="rollNumber" class="form-label">Roll Number</label>
                    <input type="text" class="form-control" id="rollNumber" name="rollNumber" 
                           value="${student.rollNumber}" readonly>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                    <a href="${pageContext.request.contextPath}/student-dash" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const img = document.querySelector('.profile-photo');
                const placeholder = document.querySelector('.profile-photo-placeholder');
                
                if (img) {
                    img.src = e.target.result;
                    img.style.display = 'block';
                    if (placeholder) placeholder.style.display = 'none';
                } else {
                    // If no image exists, create one
                    const newImg = document.createElement('img');
                    newImg.src = e.target.result;
                    newImg.className = 'profile-photo';
                    newImg.alt = 'Profile Photo';
                    placeholder.parentNode.insertBefore(newImg, placeholder);
                    placeholder.style.display = 'none';
                }
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html> 