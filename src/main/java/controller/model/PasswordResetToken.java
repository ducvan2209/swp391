package controller.model;

import java.time.LocalDateTime;

public class PasswordResetToken {
    private int tokenId;
    private int userId;
    private String token;
    private LocalDateTime expiresAt;
    private LocalDateTime usedAt;
    private LocalDateTime createdAt;

    public PasswordResetToken() {}

    public PasswordResetToken(
            int tokenId,
            int userId,
            String token,
            LocalDateTime expiresAt,
            LocalDateTime usedAt,
            LocalDateTime createdAt
    ) {
        this.tokenId = tokenId;
        this.userId = userId;
        this.token = token;
        this.expiresAt = expiresAt;
        this.usedAt = usedAt;
        this.createdAt = createdAt;
    }

    public int getTokenId() {
        return tokenId;
    }

    public void setTokenId(int tokenId) {
        this.tokenId = tokenId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(LocalDateTime usedAt) {
        this.usedAt = usedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "PasswordResetToken{" +
                "tokenId=" + tokenId +
                ", userId=" + userId +
                ", expiresAt=" + expiresAt +
                ", usedAt=" + usedAt +
                ", createdAt=" + createdAt +
                '}';
    }
}
