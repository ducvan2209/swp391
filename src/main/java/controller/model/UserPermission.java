package controller.model;

import java.time.LocalDateTime;

public class UserPermission {
    private int userPermissionId;
    private int userId;
    private int permissionId;
    private Boolean isGranted;
    private String scope;
    private Integer scopeValue;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
    private Integer createdBy;

    public UserPermission() {}

    public UserPermission(
            int userPermissionId,
            int userId,
            int permissionId,
            Boolean isGranted,
            String scope,
            Integer scopeValue,
            LocalDateTime createdDate,
            LocalDateTime updatedDate,
            Integer createdBy
    ) {
        this.userPermissionId = userPermissionId;
        this.userId = userId;
        this.permissionId = permissionId;
        this.isGranted = isGranted;
        this.scope = scope;
        this.scopeValue = scopeValue;
        this.createdDate = createdDate;
        this.updatedDate = updatedDate;
        this.createdBy = createdBy;
    }

    public int getUserPermissionId() {
        return userPermissionId;
    }

    public void setUserPermissionId(int userPermissionId) {
        this.userPermissionId = userPermissionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(int permissionId) {
        this.permissionId = permissionId;
    }

    public Boolean getIsGranted() {
        return isGranted;
    }

    public void setIsGranted(Boolean granted) {
        isGranted = granted;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public Integer getScopeValue() {
        return scopeValue;
    }

    public void setScopeValue(Integer scopeValue) {
        this.scopeValue = scopeValue;
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

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "UserPermission{" +
                "userPermissionId=" + userPermissionId +
                ", userId=" + userId +
                ", permissionId=" + permissionId +
                ", isGranted=" + isGranted +
                ", scope=" + scope +
                ", scopeValue=" + scopeValue +
                ", createdDate=" + createdDate +
                ", updatedDate=" + updatedDate +
                ", createdBy=" + createdBy +
                '}';
    }
}
