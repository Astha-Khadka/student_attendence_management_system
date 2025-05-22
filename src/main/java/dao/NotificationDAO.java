package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Notification;
import util.DatabaseConnection;

public class NotificationDAO {

    public int addNotification(Notification notif) throws SQLException {
        String sql = "INSERT INTO notifications (user_id, type, title, message, is_read) VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setObject(1, notif.getUserId());
            pstmt.setString(2, notif.getType());
            pstmt.setString(3, notif.getTitle());
            pstmt.setString(4, notif.getMessage());
            pstmt.setBoolean(5, notif.isRead());
            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        }
        return generatedId;
    }

    public boolean deleteNotification(int id) throws SQLException {
        String sql = "DELETE FROM notifications WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int affected = pstmt.executeUpdate();
            return (affected > 0);
        }
    }

    public List<Notification> loadNotifications() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT id, user_id, type, title, message, is_read, created_at FROM notifications ORDER BY created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Notification notif = new Notification();
                notif.setId(rs.getInt("id"));
                notif.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                notif.setType(rs.getString("type"));
                notif.setTitle(rs.getString("title"));
                notif.setMessage(rs.getString("message"));
                notif.setRead(rs.getBoolean("is_read"));
                notif.setCreatedAt(rs.getTimestamp("created_at"));
                notifications.add(notif);
            }
        }
        return notifications;
    }

    public List<Notification> getNotificationsForUser(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT id, user_id, type, title, message, is_read, created_at FROM notifications WHERE user_id = ? OR user_id IS NULL ORDER BY created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Notification notif = new Notification();
                    notif.setId(rs.getInt("id"));
                    notif.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                    notif.setType(rs.getString("type"));
                    notif.setTitle(rs.getString("title"));
                    notif.setMessage(rs.getString("message"));
                    notif.setRead(rs.getBoolean("is_read"));
                    notif.setCreatedAt(rs.getTimestamp("created_at"));
                    notifications.add(notif);
                }
            }
        }
        return notifications;
    }

    public boolean markAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE notifications SET is_read = true WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, notificationId);
            int affected = pstmt.executeUpdate();
            return (affected > 0);
        }
    }
}