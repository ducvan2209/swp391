package controller.dal;

import controller.model.Guest;
import controller.model.Recruitment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Concrete JDBC implementation of GuestDAO.
 * Uses LEFT JOIN to fetch Recruitment basic info alongside Guest data.
 */
public class GuestDAOImpl implements GuestDAO {

    private static final Logger LOGGER = Logger.getLogger(GuestDAOImpl.class.getName());

    // ── SQL ──────────────────────────────────────────────────────────────────

    private static final String SQL_GET_ALL =
            "SELECT g.*, r.JobTitle, r.Location, r.Salary, r.Status AS JobStatus " +
            "FROM Guest g " +
            "LEFT JOIN Recruitment r ON g.RecruitmentID = r.RecruitmentID";

    private static final String SQL_GET_DETAIL =
            "SELECT g.*, r.JobTitle, r.Location, r.Salary, r.Status AS JobStatus " +
            "FROM Guest g " +
            "LEFT JOIN Recruitment r ON g.RecruitmentID = r.RecruitmentID " +
            "WHERE g.GuestID = ?";

    // ── Public interface methods ─────────────────────────────────────────────

    @Override
    public List<Guest> getAllGuests() {
        List<Guest> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToGuest(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching guest list", ex);
        }
        return list;
    }

    @Override
    public Guest getGuestDetail(int guestId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_DETAIL)) {

            ps.setInt(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToGuest(rs);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching guest detail for id=" + guestId, ex);
        }
        return null;
    }

    // ── Row mappers ──────────────────────────────────────────────────────────

    private Guest mapRowToGuest(ResultSet rs) throws SQLException {
        Guest guest = new Guest();
        guest.setGuestId(rs.getInt("GuestID"));
        guest.setFullName(rs.getString("FullName"));
        guest.setEmail(rs.getString("Email"));
        guest.setPhone(rs.getString("Phone"));
        guest.setCv(rs.getString("CV"));
        guest.setStatus(rs.getString("Status"));

        int recruitmentId = rs.getInt("RecruitmentID");
        if (!rs.wasNull()) {
            guest.setRecruitmentId(recruitmentId);
        }

        Timestamp appliedTs = rs.getTimestamp("AppliedDate");
        if (appliedTs != null) {
            guest.setAppliedDate(appliedTs.toLocalDateTime());
        }

        // Map Recruitment info from JOIN — may be null if no match
        String jobTitle = rs.getString("JobTitle");
        if (jobTitle != null) {
            Recruitment recruitment = new Recruitment();
            recruitment.setRecruitmentId(recruitmentId);
            recruitment.setJobTitle(jobTitle);
            recruitment.setLocation(rs.getString("Location"));
            recruitment.setSalary(rs.getDouble("Salary"));
            recruitment.setStatus(rs.getString("JobStatus"));
            guest.setRecruitment(recruitment);
        }

        return guest;
    }
}
