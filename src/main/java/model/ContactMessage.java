package model;

import java.util.Date;

public class ContactMessage {
    private int id;
    private int userId;
    private String title;
    private String description;
    private Date createdAt;

    // Constructors
    public ContactMessage() {
    }

    public ContactMessage(int userId, String title, String description, Date createdAt) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "ContactMessage{" +
               "id=" + id +
               ", userId=" + userId +
               ", title='" + title + '\'' +
               ", description='" + description + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
} 