package dao;

import model.Student;
import model.Teacher;
import model.User;
import util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TeacherDAO {
    private static final Logger LOGGER = Logger.getLogger(TeacherDAO.class.getName());

    public boolean saveTeacherData(Teacher teacher, String employeeId, String department, String photoPath) {
        String sql = "INSERT INTO teacher (user_id, employee_id, department, photo_path) VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE employee_id = ?, department = ?, photo_path = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, teacher.getId());
            pstmt.setString(2, employeeId);
            pstmt.setString(3, department);
            pstmt.setString(4, photoPath != null ? photoPath : teacher.getPhotoPath());
            pstmt.setString(5, employeeId);
            pstmt.setString(6, department);
            pstmt.setString(7, photoPath != null ? photoPath : teacher.getPhotoPath());
            int rows = pstmt.executeUpdate();
            LOGGER.info("Saved teacher data for user ID: " + teacher.getId() + ", rows affected: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving teacher data for user ID: " + teacher.getId(), e);
            return false;
        }
    }

    public Teacher getTeacherData(int userId) throws SQLException {
        String sql = "SELECT u.id, u.username, u.email, u.role, t.employee_id, t.department, t.photo_path " +
                "FROM users u LEFT JOIN teacher t ON u.id = t.user_id WHERE u.id = ? AND u.role = 'teacher'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Teacher teacher = new Teacher();
                    teacher.setId(rs.getInt("id"));
                    teacher.setUsername(rs.getString("username"));
                    teacher.setEmail(rs.getString("email"));
                    teacher.setRole(rs.getString("role"));
                    teacher.setEmployeeId(rs.getString("employee_id"));
                    teacher.setDepartment(rs.getString("department"));
                    String photoPath = rs.getString("photo_path");
                    teacher.setPhotoPath(photoPath != null ? photoPath : "");
                    return teacher;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching teacher data for user ID: " + userId, e);
            throw e;
        }
        return null;
    }

    public List<Student> getAllStudents() throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.email, u.role, s.rollno, s.classname, s.photo_path " +
                "FROM users u JOIN student s ON u.id = s.user_id WHERE u.role = 'student'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setUsername(rs.getString("username"));
                student.setEmail(rs.getString("email"));
                student.setRole(rs.getString("role"));
                String photoPath = rs.getString("photo_path");
                student.setPhotoPath(photoPath != null ? photoPath : "");
                student.setRollNumber(rs.getString("rollno"));
                student.setClassName(rs.getString("classname"));
                students.add(student);
            }
            LOGGER.info("Fetched " + students.size() + " students from the database.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching students", e);
            throw e;
        }
        return students;
    }
    public String getStudentPhotoPath(int studentId) throws SQLException {
        String photoPath = null;
        String query = "SELECT photo_path FROM student WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    photoPath = rs.getString("photo_path");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching photo path for student ID: " + studentId, e);
            throw e;
        }
        return photoPath;
    }

    public boolean deleteStudent(int studentId) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt1 = null, stmt2 = null, stmt3 = null;
        boolean success = false;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // Delete from attendance
            stmt1 = conn.prepareStatement("DELETE FROM attendance WHERE student_id = ?");
            stmt1.setInt(1, studentId);
            stmt1.executeUpdate();

            // Delete from student
            stmt2 = conn.prepareStatement("DELETE FROM student WHERE user_id = ?");
            stmt2.setInt(1, studentId);
            int rowsAffected = stmt2.executeUpdate();

            // Delete from users
            stmt3 = conn.prepareStatement("DELETE FROM users WHERE id = ?");
            stmt3.setInt(1, studentId);
            stmt3.executeUpdate();

            if (rowsAffected > 0) {
                conn.commit();
                success = true;
                LOGGER.info("Successfully deleted student with ID: " + studentId);
            } else {
                conn.rollback();
                LOGGER.warning("No student found with ID: " + studentId);
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    LOGGER.info("Rolled back deletion for student ID: " + studentId);
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Rollback failed for student ID: " + studentId, ex);
                    throw new SQLException("Rollback failed", ex);
                }
            }
            LOGGER.log(Level.SEVERE, "Error deleting student with ID: " + studentId, e);
            throw e;
        } finally {
            if (stmt1 != null) try { stmt1.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Failed to close stmt1", e); }
            if (stmt2 != null) try { stmt2.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Failed to close stmt2", e); }
            if (stmt3 != null) try { stmt3.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Failed to close stmt3", e); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { LOGGER.log(Level.WARNING, "Failed to close connection", e); }
        }
        return success;
    }
}
