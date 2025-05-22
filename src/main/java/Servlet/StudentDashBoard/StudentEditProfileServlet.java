package Servlet.StudentDashBoard;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Student;
import model.User;

@WebServlet("/student-edit-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 3, // 3MB
    maxFileSize = 1024 * 1024 * 5, // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class StudentEditProfileServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentEditProfileServlet.class.getName());
    public static final String UPLOAD_DIR = "Images";
    private static final String[] ALLOWED_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif" };

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            LOGGER.info("Unauthorized access attempt, redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
            return;
        }

        // Fetch student data
        StudentDAO studentDAO = new StudentDAO();
        Student student = null;
        try {
            student = studentDAO.getStudentById(user.getId());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching student data for ID: " + user.getId(), e);
            request.setAttribute("error", "Error loading student profile.");
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                    .forward(request, response);
            return;
        }

        if (student != null) {
            request.setAttribute("student", student);
            LOGGER.info("Forwarding to studentEditProfile.jsp for user ID: " + user.getId());
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                    .forward(request, response);
        } else {
            LOGGER.warning("Student not found for user ID: " + user.getId());
            request.setAttribute("error", "Student data not found.");
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"student".equalsIgnoreCase(user.getRole())) {
            LOGGER.info("Unauthorized access attempt, redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/Nav_login?error=unauthenticated");
            return;
        }

        LOGGER.info("Processing student profile update for user ID: " + user.getId());

        // Retrieve form fields
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String className = request.getParameter("className");
        String rollNumber = request.getParameter("rollNumber");
        Part photoPart = request.getPart("photo");

        // Validate inputs
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$") ||
            className == null || className.trim().isEmpty()) {
            LOGGER.warning("Validation failed for user ID: " + user.getId());
            request.setAttribute("error", "All fields are required and email must be valid.");
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                    .forward(request, response);
            return;
        }

        // Handle photo upload
        String photoFileName = null;
        if (photoPart != null && photoPart.getSize() > 0) {
            String fileName = photoPart.getSubmittedFileName();
            String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            
            if (!isValidExtension(extension)) {
                LOGGER.warning("Invalid file extension for user ID: " + user.getId() + ": " + extension);
                request.setAttribute("error", "Only image files (.jpg, .jpeg, .png, .gif) are allowed.");
                request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                        .forward(request, response);
                return;
            }

            // Generate unique filename
            fileName = UUID.randomUUID() + extension;
            
            // Get the upload path
            String uploadPath = getServletContext().getRealPath("/") + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Save the file
            String filePath = uploadPath + File.separator + fileName;
            try {
                photoPart.write(filePath);
                photoFileName = fileName;
                LOGGER.info("Photo uploaded successfully to: " + filePath);
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Failed to write photo to: " + filePath, e);
                request.setAttribute("error", "Error saving uploaded photo.");
                request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                        .forward(request, response);
                return;
            }
        }

        // Update student data
        StudentDAO studentDAO = new StudentDAO();
        Student student = new Student();
        student.setId(user.getId());
        student.setUsername(username);
        student.setEmail(email);
        student.setClassName(className);
        student.setRollNumber(rollNumber);
        
        if (photoFileName != null) {
            student.setPhotoPath(photoFileName);
        } else {
            // Keep existing photo if no new one is uploaded
            try {
                Student existingStudent = studentDAO.getStudentById(user.getId());
                if (existingStudent != null) {
                    student.setPhotoPath(existingStudent.getPhotoPath());
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching existing student data", e);
                request.setAttribute("error", "Error retrieving existing profile data.");
                request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                        .forward(request, response);
                return;
            }
        }

        try {
            boolean updated = studentDAO.updateStudent(student);
            if (updated) {
                // Update session with both User and Student objects
                User updatedUser = new User();
                updatedUser.setId(user.getId());
                updatedUser.setUsername(student.getUsername());
                updatedUser.setEmail(student.getEmail());
                updatedUser.setRole("student");
                
                request.getSession().setAttribute("user", updatedUser);
                request.getSession().setAttribute("student", student);
                request.getSession().setAttribute("successMessage", "Profile updated successfully!");
                response.sendRedirect(request.getContextPath() + "/student-dash");
            } else {
                request.setAttribute("error", "Failed to update profile. Please try again.");
                request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                        .forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating student data", e);
            request.setAttribute("error", "Database error: Unable to update profile.");
            request.getRequestDispatcher("/WEB-INF/view/student_dashboard_functionality/studentEditProfile.jsp")
                    .forward(request, response);
        }
    }

    private boolean isValidExtension(String fileExtension) {
        for (String allowedExtension : ALLOWED_EXTENSIONS) {
            if (allowedExtension.equals(fileExtension)) {
                return true;
            }
        }
        return false;
    }
}