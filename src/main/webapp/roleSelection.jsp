<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 4/6/2025
  Time: 12:07 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Role Selection</title>
</head>
<body>
    <form action="redirectToRegister" method="post">
    <input type="radio" name="role" value="student" required> Student
    <input type="radio" name="role" value="admin" required> Admin
    <input type="submit" value="Submit">`
    </form>
</body>
</html>
