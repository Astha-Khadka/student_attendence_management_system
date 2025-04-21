package util;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/student_attendance_management_system";
    private static final String USER = "root";
    private static final String PASSWORD = "password"; // Change to your actual password

    /**
     * Gets a database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            // Load mySQl JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create and return connection
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            // This should never happen if JDBC driver is in classpath
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
    }

    /**
     * Closes a database connection quietly (no exception thrown)
     * @param conn Connection to close
     */

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                // Log this error in a real application
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }

}

