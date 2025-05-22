package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.ContactMessage;
import util.DatabaseConnection;

public class ContactMessageDAO {
    private static final Logger LOGGER = Logger.getLogger(ContactMessageDAO.class.getName());

    private static final String INSERT_MESSAGE_SQL = "INSERT INTO contact_messages (user_id, title, description) VALUES (?, ?, ?)";
    private static final String GET_ALL_MESSAGES_SQL = "SELECT * FROM contact_messages ORDER BY created_at DESC";
    private static final String GET_MESSAGE_BY_ID_SQL = "SELECT * FROM contact_messages WHERE id = ?";

    public boolean saveMessage(ContactMessage message) throws SQLException {
        LOGGER.info("Attempting to save contact message for user ID: " + message.getUserId());
        boolean rowInserted = false;
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_MESSAGE_SQL)) {

            preparedStatement.setInt(1, message.getUserId());
            preparedStatement.setString(2, message.getTitle());
            preparedStatement.setString(3, message.getDescription());

            rowInserted = preparedStatement.executeUpdate() > 0;
            LOGGER.info("Contact message save status for user ID " + message.getUserId() + ": " + rowInserted);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving contact message for user ID: " + message.getUserId(), e);
            throw e;
        }
        return rowInserted;
    }

    public List<ContactMessage> getAllContactMessages() throws SQLException {
        List<ContactMessage> messages = new ArrayList<>();
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_MESSAGES_SQL);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                ContactMessage message = new ContactMessage();
                message.setId(resultSet.getInt("id"));
                message.setUserId(resultSet.getInt("user_id"));
                message.setTitle(resultSet.getString("title"));
                message.setDescription(resultSet.getString("description"));
                message.setCreatedAt(resultSet.getTimestamp("created_at"));
                messages.add(message);
            }
        }
        return messages;
    }

    public ContactMessage getContactMessageById(int id) throws SQLException {
        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(GET_MESSAGE_BY_ID_SQL)) {

            preparedStatement.setInt(1, id);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    ContactMessage message = new ContactMessage();
                    message.setId(resultSet.getInt("id"));
                    message.setUserId(resultSet.getInt("user_id"));
                    message.setTitle(resultSet.getString("title"));
                    message.setDescription(resultSet.getString("description"));
                    message.setCreatedAt(resultSet.getTimestamp("created_at"));
                    return message;
                }
            }
        }
        return null;
    }
} 