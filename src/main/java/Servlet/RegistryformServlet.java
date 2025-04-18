package Servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/Registryform")
public class RegistryformServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward the request to the register.jsp inside WEB-INF/view
        request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
    }
}

//@WebServlet("/Adminpage")
//public class AdminpageServlet extends HttpServlet {
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        // Forward the request to the register.jsp inside WEB-INF/view
//        request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
//    }
//}