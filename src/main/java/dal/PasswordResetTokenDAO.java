package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PasswordResetTokenDAO extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(PasswordResetTokenDAO.class.getName());

    public void invalidateTokensForEmployee(int empId) {
        String sql = "UPDATE PasswordResetToken SET used = TRUE WHERE emp_id = ? AND used = FALSE";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, empId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Could not invalidate reset tokens: {0}", ex.getMessage());
        }
    }

    public boolean saveToken(int empId, String token, LocalDateTime expiresAt) {
        invalidateTokensForEmployee(empId);
        String sql = "INSERT INTO PasswordResetToken (emp_id, token, expires_at) VALUES (?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, empId);
            stm.setString(2, token);
            stm.setTimestamp(3, Timestamp.valueOf(expiresAt));
            return stm.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not save reset token", ex);
            return false;
        }
    }

    public Integer findEmpIdByValidToken(String token) {
        String sql = "SELECT emp_id FROM PasswordResetToken "
                + "WHERE token = ? AND used = FALSE AND expires_at > NOW() LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, token);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("emp_id");
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Reset token lookup failed: {0}", ex.getMessage());
        }
        return null;
    }

    public boolean markTokenUsed(String token) {
        String sql = "UPDATE PasswordResetToken SET used = TRUE WHERE token = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setString(1, token);
            return stm.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not mark token used", ex);
            return false;
        }
    }
}
