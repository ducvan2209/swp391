package dal;

import model.Department;
import model.Employee;
import model.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data access for authentication and employee session (Task 1 scope).
 */
public class EmployeeDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(EmployeeDAO.class.getName());

    private static final String BASE_SELECT_SQL = "SELECT e.*, "
            + "d.dep_name, d.description AS dep_description, "
            + "r.role_name "
            + "FROM Employee e "
            + "LEFT JOIN Department d ON e.dep_id = d.dep_id "
            + "LEFT JOIN Role r ON e.role_id = r.role_id ";

    private Employee mapResultSetToEmployee(ResultSet rs) throws SQLException {
        Department dept = new Department();
        dept.setDepId(rs.getString("dep_id"));
        dept.setDepName(rs.getString("dep_name"));
        dept.setDescription(rs.getString("dep_description"));

        Role role = new Role();
        int roleId = rs.getInt("role_id");
        if (!rs.wasNull()) {
            role.setRoleId(roleId);
            role.setRoleName(rs.getString("role_name"));
        }

        Employee emp = new Employee();
        emp.setEmpId(rs.getInt("emp_id"));
        emp.setEmpCode(rs.getString("emp_code"));
        emp.setFullname(rs.getString("fullname"));
        emp.setEmail(rs.getString("email"));
        emp.setPassword(rs.getString("password"));
        emp.setGender(rs.getBoolean("gender"));
        emp.setDob(rs.getDate("dob"));
        emp.setPhone(rs.getString("phone"));
        emp.setPositionTitle(rs.getString("position_title"));
        emp.setImage(rs.getString("image"));
        emp.setPaidLeaveDays(rs.getInt("paid_leave_days"));
        emp.setStatus(rs.getBoolean("status"));
        emp.setDept(dept);
        emp.setRole(role);
        try {
            emp.setEmailVerified(rs.getBoolean("email_verified"));
            emp.setFailedLoginCount(rs.getInt("failed_login_count"));
            emp.setLockedUntil(rs.getTimestamp("locked_until"));
        } catch (SQLException ignored) {
            emp.setEmailVerified(true);
            emp.setFailedLoginCount(0);
            emp.setLockedUntil(null);
        }
        return emp;
    }

    public Employee getEmployeeByEmailForAuth(String email) {
        String sql = BASE_SELECT_SQL + " WHERE LOWER(e.email) = LOWER(?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, email.trim());
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "getEmployeeByEmailForAuth failed", ex);
        }
        return null;
    }

    public Employee getEmployeeByEmpCode(String empCode) {
        String sql = BASE_SELECT_SQL + " WHERE e.emp_code = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, empCode);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "getEmployeeByEmpCode failed", ex);
        }
        return null;
    }

    public Employee getEmployeeByEmpId(int empId) {
        String sql = BASE_SELECT_SQL + " WHERE e.emp_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, empId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEmployee(rs);
                }
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "getEmployeeByEmpId failed", ex);
        }
        return null;
    }

    public void resetFailedLogin(String empCode) {
        String sql = "UPDATE Employee SET failed_login_count = 0, locked_until = NULL WHERE emp_code = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, empCode);
            stm.executeUpdate();
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "resetFailedLogin failed", ex);
        }
    }

    public void recordFailedLogin(String empCode, int failedCount, java.sql.Timestamp lockedUntil) {
        String sql = "UPDATE Employee SET failed_login_count = ?, locked_until = ? WHERE emp_code = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, failedCount);
            if (lockedUntil == null) {
                stm.setNull(2, java.sql.Types.TIMESTAMP);
            } else {
                stm.setTimestamp(2, lockedUntil);
            }
            stm.setString(3, empCode);
            stm.executeUpdate();
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "recordFailedLogin failed", ex);
        }
    }

    public Employee refreshEmployeeSession(String empCode) {
        Employee employee = getEmployeeByEmpCode(empCode);
        if (employee != null) {
            employee.setPassword(null);
        }
        return employee;
    }

    public boolean updatePassword(String empCode, String hashedPassword) {
        String sql = "UPDATE Employee SET password = ? WHERE emp_code = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, hashedPassword);
            stm.setString(2, empCode);
            return stm.executeUpdate() > 0;
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "updatePassword failed", ex);
        }
        return false;
    }
}
