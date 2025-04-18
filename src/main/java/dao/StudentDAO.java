package dao;

import model.User;
import util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class StudentDAO {

    // Saves student-related data to the student table.
    public boolean saveStudentData(User user, String rollNo, String className) {

        // SQL query to insert user_id, roll number, and class name into the student table.
        String sql = "INSERT INTO student (user_id, rollno, classname) VALUES (?, ?, ?)";

        // try-with-resources: automatically closes connection and statement.
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // Set the user ID from the User object into the query.
            pstmt.setInt(1, user.getId());

            // Set the roll number into the query.
            pstmt.setString(2, rollNo);

            // Set the class name into the query.
            pstmt.setString(3, className);

            // Execute the insert statement. Returns number of affected rows.
            int rows = pstmt.executeUpdate();

            // Return true if insert was successful.
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();  // Print error if something goes wrong.
            return false;
        }
    }
}
