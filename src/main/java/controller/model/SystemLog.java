package controller.model;

import java.time.LocalDateTime;

public class SystemLog {
    private int logId;
    private int userId;
    private String action;
    private String objectType;
    private String oldValue;
    private String newValue;
    private LocalDateTime timestamp;

    public SystemLog() {}

    public SystemLog(
            int logId,
            int userId,
            String action,
            String objectType,
            String oldValue,
            String newValue,
            LocalDateTime timestamp
    ) {
        this.logId = logId;
        this.userId = userId;
        this.action = action;
        this.objectType = objectType;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.timestamp = timestamp;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getObjectType() {
        return objectType;
    }

    public void setObjectType(String objectType) {
        this.objectType = objectType;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "SystemLog{" +
                "logId=" + logId +
                ", userId=" + userId +
                ", action=" + action +
                ", objectType=" + objectType +
                ", timestamp=" + timestamp +
                '}';
    }
}
