package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ActivityLogDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(ActivityLogDAO.class.getName());

    public void insert(Integer empId, String action, String ipAddress, String details) {
        String sql = "INSERT INTO ActivityLog (emp_id, action, ip_address, details) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            if (empId == null) {
                stm.setNull(1, java.sql.Types.INTEGER);
            } else {
                stm.setInt(1, empId);
            }
            stm.setString(2, action);
            stm.setString(3, ipAddress);
            stm.setString(4, details);
            stm.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Activity log skipped (run sql/auth_migration.sql): {0}", ex.getMessage());
        }
    }
}
