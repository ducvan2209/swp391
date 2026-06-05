package controller.dal;

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
 * Concrete JDBC implementation of RecruitmentDAO.
 */
public class RecruitmentDAOImpl implements RecruitmentDAO {

    private static final Logger LOGGER = Logger.getLogger(RecruitmentDAOImpl.class.getName());

    private static final String SQL_GET_ALL =
            "SELECT RecruitmentID, JobTitle, JobDescription, Requirement, Location, Salary, Status, PostedDate, Applicant " +
            "FROM Recruitment ORDER BY PostedDate DESC";

    private static final String SQL_GET_BY_ID =
            "SELECT RecruitmentID, JobTitle, JobDescription, Requirement, Location, Salary, Status, PostedDate, Applicant " +
            "FROM Recruitment WHERE RecruitmentID = ?";

    private static final String SQL_INSERT =
            "INSERT INTO Recruitment (JobTitle, JobDescription, Requirement, Location, Salary, Status, Applicant) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

    @Override
    public boolean insertRecruitment(Recruitment rec) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {

            ps.setString(1, rec.getJobTitle());
            ps.setString(2, rec.getJobDescription());
            ps.setString(3, rec.getRequirement());
            ps.setString(4, rec.getLocation());
            ps.setDouble(5, rec.getSalary());
            ps.setString(6, rec.getStatus() != null ? rec.getStatus() : "New");
            ps.setInt(7, rec.getApplicant() > 0 ? rec.getApplicant() : 1);

            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting recruitment: " + rec.getJobTitle(), ex);
            return false;
        }
    }

    @Override
    public List<Recruitment> getAllRecruitments() {
        List<Recruitment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToRecruitment(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching recruitment list", ex);
        }
        return list;
    }

    @Override
    public Recruitment getRecruitmentById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToRecruitment(rs);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching recruitment detail for id=" + id, ex);
        }
        return null;
    }

    private Recruitment mapRowToRecruitment(ResultSet rs) throws SQLException {
        Recruitment rec = new Recruitment();
        rec.setRecruitmentId(rs.getInt("RecruitmentID"));
        rec.setJobTitle(rs.getString("JobTitle"));
        rec.setJobDescription(rs.getString("JobDescription"));
        rec.setRequirement(rs.getString("Requirement"));
        rec.setLocation(rs.getString("Location"));
        rec.setSalary(rs.getDouble("Salary"));
        rec.setStatus(rs.getString("Status"));

        Timestamp ts = rs.getTimestamp("PostedDate");
        if (ts != null) {
            rec.setPostedDate(ts.toLocalDateTime());
        }

        rec.setApplicant(rs.getInt("Applicant"));
        return rec;
    }
}
