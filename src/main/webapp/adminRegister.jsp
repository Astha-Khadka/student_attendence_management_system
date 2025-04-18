<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register as Admin</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f7f7f7; color: #333;">

<!-- Navbar -->
<div style="background-color: #007BFF; padding: 15px; text-align: center; display: flex; justify-content: center; align-items: center;">
    <div style="display: flex; align-items: center; gap: 10px;">
        <img src="your-logo.png" alt="Logo" style="width: 50px; height: 50px; vertical-align: middle;">
        <span style="font-size: 1.5rem; color: white;">Student Attendance</span>
    </div>
    <a href="home.jsp" style="color: white; text-decoration: none; padding: 12px 20px; font-size: 1.1rem; margin: 0 15px; transition: background-color 0.3s;">Home</a>
    <a href="register.jsp" style="color: white; text-decoration: none; padding: 12px 20px; font-size: 1.1rem; margin: 0 15px; transition: background-color 0.3s;">Register</a>
    <a href="login.jsp" style="color: white; text-decoration: none; padding: 12px 20px; font-size: 1.1rem; margin: 0 15px; transition: background-color 0.3s;">Login</a>
    <a href="about.jsp" style="color: white; text-decoration: none; padding: 12px 20px; font-size: 1.1rem; margin: 0 15px; transition: background-color 0.3s;">About</a>
</div>

<!-- Header -->
<div style="text-align: center; padding: 50px 20px;">
    <h1 style="font-size: 3rem; color: #4CAF50; margin-bottom: 20px;">Register as Admin</h1>
    <p style="font-size: 1.2rem; color: #555; margin-bottom: 30px;">Please fill out the form to register as an admin.</p>
</div>

<!-- Main Content (Form) -->
<div style="display: flex; justify-content: center; align-items: center; height: 60vh;">
    <div style="background-color: #fff; padding: 40px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); text-align: center; width: 100%; max-width: 400px;">
        <form action="registerAdmin" method="post">
            <label for="name" style="display: block; text-align: left; margin-bottom: 8px;">Name:</label>
            <input type="text" name="name" id="name" required style="width: 100%; padding: 12px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc;">

            <label for="email" style="display: block; text-align: left; margin-bottom: 8px;">Email:</label>
            <input type="email" name="email" id="email" required style="width: 100%; padding: 12px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc;">

            <label for="password" style="display: block; text-align: left; margin-bottom: 8px;">Password:</label>
            <input type="password" name="password" id="password" required style="width: 100%; padding: 12px; margin: 8px 0; border-radius: 5px; border: 1px solid #ccc;">

            <input type="submit" value="Register as Admin" style="background-color: #4CAF50; color: white; padding: 12px 20px; border-radius: 5px; font-size: 1rem; margin-top: 20px; cursor: pointer; border: none; transition: background-color 0.3s;">
        </form>
    </div>
</div>

<!-- Footer -->
<div style="background-color: #007BFF; color: white; text-align: center; padding: 20px; position: absolute; bottom: 0; width: 100%;">
    <p style="margin: 0; font-size: 1rem;">&copy; 2025 Student Attendance System. All rights reserved.</p>
</div>

</body>
</html>
