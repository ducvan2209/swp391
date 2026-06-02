package controller.model;

import java.time.LocalDateTime;

public class RolePermission {
    private int rolePermissionId;
    private int roleId;
    private int permissionId;
    private LocalDateTime createdDate;

    public RolePermission() {}

    public RolePermission(int rolePermissionId, int roleId, int permissionId, LocalDateTime createdDate) {
        this.rolePermissionId = rolePermissionId;
        this.roleId = roleId;
        this.permissionId = permissionId;
        this.createdDate = createdDate;
    }

    public int getRolePermissionId() {
        return rolePermissionId;
    }

    public void setRolePermissionId(int rolePermissionId) {
        this.rolePermissionId = rolePermissionId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(int permissionId) {
        this.permissionId = permissionId;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "RolePermission{" +
                "rolePermissionId=" + rolePermissionId +
                ", roleId=" + roleId +
                ", permissionId=" + permissionId +
                ", createdDate=" + createdDate +
                '}';
    }
}
