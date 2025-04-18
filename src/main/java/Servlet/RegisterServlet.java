package Servlet;
import dao.StudentDAO;
import dao.TeacherDAO;
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Admin;
import model.Student;
import model.Teacher;
import model.User;

import java.io.IOException;
import java.util.Date;



@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
//        String role = request.getParameter("role");

        User user = null;

        switch (role.toLowerCase()) {
            case "admin":
                user = new Admin();
                break;
            case "student":
                user = new Student();
                break;
            case "teacher":
                user = new Teacher();
                break;
            default:
                response.getWriter().println("Invalid role");
                return;

        }
        //fill the common data of the users
    user.setUsername(username);
    user.setPassword(password);
    user.setEmail(email);
    user.setRole(role);
    user.setCreatedAt(new Date());

    //insert into users table
    UserDAO userDAO = new UserDAO();
    boolean userRegistered  = userDAO.registerUser(user);

    if (!userRegistered) {
        response.getWriter().println("Failed to register user.");
        return;
    }

    //if common user info saved sucessfully, save role-specific info
        switch (role.toLowerCase()) {
            case "student":

                String rollNo = request.getParameter("rollno");
                String className = request.getParameter("classname");
                StudentDAO studentDAO = new StudentDAO();
                boolean studentSaved = studentDAO.saveStudentData(user, rollNo, className);
                if (studentSaved) {
                    response.sendRedirect("student_home.jsp");
                } else {
                    response.getWriter().println("Student data not saved.");
                }
                break;


            case "teacher":
                String employeeId = request.getParameter("employeeID");
                String department = request.getParameter("department");
                TeacherDAO teacherDAO = new TeacherDAO();
                boolean teacherSaved = teacherDAO.saveTeacherData(user, employeeId, department);
                if (teacherSaved) {
                    response.sendRedirect("teacher_home.jsp");
                } else {
                    response.getWriter().println("Teacher data not saved.");
                }
                break;

            case "admin":
                // For Admin: if no extra info is needed, just redirect
                response.sendRedirect("/adminpage");
                break;
        }

    }


}