package controller.model;

import java.time.LocalDateTime;

public class SystemUser {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private String googleId;
    private String avatarUrl;
    private String loginProvider;
    private int roleId;
    private Integer employeeId;
    private Integer failedLoginAttempt;
    private LocalDateTime lockedUntil;
    private LocalDateTime lastLogin;
    private Boolean isActive;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;

    public SystemUser() {}

    @SuppressWarnings("java:S107")
    public SystemUser(
            int userId,
            String username,
            String email,
            String passwordHash,
            String googleId,
            String avatarUrl,
            String loginProvider,
            int roleId,
            Integer employeeId,
            Integer failedLoginAttempt,
            LocalDateTime lockedUntil,
            LocalDateTime lastLogin,
            Boolean isActive,
            LocalDateTime createdDate,
            LocalDateTime updatedDate
    ) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.googleId = googleId;
        this.avatarUrl = avatarUrl;
        this.loginProvider = loginProvider;
        this.roleId = roleId;
        this.employeeId = employeeId;
        this.failedLoginAttempt = failedLoginAttempt;
        this.lockedUntil = lockedUntil;
        this.lastLogin = lastLogin;
        this.isActive = isActive;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getLoginProvider() {
        return loginProvider;
    }

    public void setLoginProvider(String loginProvider) {
        this.loginProvider = loginProvider;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
        this.employeeId = employeeId;
    }

    public Integer getFailedLoginAttempt() {
        return failedLoginAttempt;
    }

    public void setFailedLoginAttempt(Integer failedLoginAttempt) {
        this.failedLoginAttempt = failedLoginAttempt;
    }

    public LocalDateTime getLockedUntil() {
        return lockedUntil;
    }

    public void setLockedUntil(LocalDateTime lockedUntil) {
        this.lockedUntil = lockedUntil;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public LocalDateTime getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(LocalDateTime updatedDate) {
        this.updatedDate = updatedDate;
    }

    @Override
    public String toString() {
        return "SystemUser{" +
                "userId=" + userId +
                ", username=" + username +
                ", email=" + email +
                ", googleId=" + googleId +
                ", loginProvider=" + loginProvider +
                ", roleId=" + roleId +
                ", employeeId=" + employeeId +
                ", failedLoginAttempt=" + failedLoginAttempt +
                ", lockedUntil=" + lockedUntil +
                ", lastLogin=" + lastLogin +
                ", isActive=" + isActive +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                '}';
    }
}
