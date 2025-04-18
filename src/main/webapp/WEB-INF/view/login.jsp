<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 4/16/2025
  Time: 11:35 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Login</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; color: #333; min-height: 100vh; display: flex; flex-direction: column;">

<!-- Navbar -->
<div style="background-color: #007BFF; padding: 15px; display: flex; justify-content: center; align-items: center;">
    <img src="your-logo.png" alt="Logo" style="width: 50px; height: 50px; vertical-align: middle;">
    <span style="font-size: 1.5rem; color: white; margin-left: 10px;">Student Attendance Management System</span>
</div>

<!-- Header -->
<div style="text-align: center; padding: 50px 20px;">
    <h1 style="font-size: 3rem; color: #4CAF50; margin-bottom: 20px;">User Login</h1>
    <p style="font-size: 1.2rem; color: #555; margin-bottom: 30px;">Enter your credentials to access your account.</p>
</div>

<!-- Main Content (Form) -->
<div style="flex: 1; display: flex; justify-content: center; align-items: center;">
    <div style="background-color: #fff; padding: 40px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); text-align: center; width: 100%; max-width: 400px;">
        <form action="LoginServlet" method="post">

            <label for="username" style="display: block; text-align: left; margin-bottom: 8px;">Username:</label>
            <input type="text" name="username" id="username" required
                   style="width: 100%; padding: 12px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc;">

            <label for="email" style="display: block; text-align: left; margin-bottom: 8px;">Email:</label>
            <input type="email" name="email" id="email" required
                   style="width: 100%; padding: 12px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc;">

            <label for="password" style="display: block; text-align: left; margin-bottom: 8px;">Password:</label>
            <input type="password" name="password" id="password" required
                   style="width: 100%; padding: 12px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc;">

            <label for="role" style="display: block; text-align: left; margin-bottom: 8px;">Role:</label>
            <select name="role" id="role" required
                    style="width: 100%; padding: 12px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc;">
                <option value="">Select Role</option>
                <option value="admin">Admin</option>
                <option value="student">Student</option>
                <option value="teacher">Teacher</option>
            </select>

            <input type="submit" value="Login"
                   style="background-color: #4CAF50; color: white; padding: 12px 20px; border-radius: 5px; font-size: 1rem; margin-top: 20px; cursor: pointer; border: none; transition: background-color 0.3s;">
        </form>
    </div>
</div>

<!-- Footer -->
<div style="background-color: #007BFF; color: white; text-align: center; padding: 20px;">
    <p>&copy; 2025 Student Attendance System. All rights reserved.</p>
</div>

</body>
</html>
