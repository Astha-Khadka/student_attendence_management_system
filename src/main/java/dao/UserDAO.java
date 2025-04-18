package dao;

import model.User;
import model.Admin;
import model.Student;
import model.Teacher;
import util.DatabaseConnection;
import java.sql.*;

public class UserDAO {

    public User authenticate(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");
                // Instantiate the appropriate subclass based on role
                user = createUserFromRole(role);
                if (user != null) {
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(role);
//                    user.setFirstName(rs.getString("first_name")); // Assuming column exists
//                    user.setLastName(rs.getString("last_name"));   // Assuming column exists
                    user.setEmail(rs.getString("email"));          // Assuming column exists
                    user.setCreatedAt(rs.getDate("created_at"));   // Assuming column exists
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error authenticating user: " + e.getMessage());
        }
        return user;
    }

    //fetch user by their unique id
    public User getUserById(int id) {
        User user = null;
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {    //prepare sql query

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {    //id user exists
                String role = rs.getString("role");     //get the role
                // Instantiate the appropriate subclass based on role
                user = createUserFromRole(role);
                if (user != null) {     //Assign values
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(role);
                    user.setEmail(rs.getString("email"));          // Assuming column exists
                    user.setCreatedAt(rs.getDate("created_at"));   // Assuming column exists
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error retrieving user by ID: " + e.getMessage());
        }
        return user;
    }

    // Helper method to create the appropriate User subclass based on role
    private User createUserFromRole(String role) {
        switch (role.toLowerCase()) {
            case "admin":
                return new Admin();
            case "student":
                return new Student();
            case "teacher":
                return new Teacher();
            default:
                return null; // Or throw an exception if role is invalid
        }
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO user (username, password, role, email, created_at) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(4, user.getRole());
            pstmt.setString(3, user.getEmail());
//            pstmt.setString(4, user.getRole());

            java.sql.Date sqlDate = new java.sql.Date(user.getCreatedAt().getTime());
            pstmt.setDate(5, sqlDate);

            int rows = pstmt.executeUpdate();       //insert row

            if (rows > 0) {
                ResultSet generatedKeys = pstmt.getGeneratedKeys();  // Retrieve the generated ID.
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));  // Set the ID in the user object.
                }
                return true;
            } else {
                return false;  // Insert failed.
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error registering user: " + e.getMessage());
        }
    }

}