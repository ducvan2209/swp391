package controller.dal;

import controller.model.Contract;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Concrete JDBC implementation of ContractDAO.
 */
public class ContractDAOImpl implements ContractDAO {

    private static final Logger LOGGER = Logger.getLogger(ContractDAOImpl.class.getName());

    // ── SQL ──────────────────────────────────────────────────────────────────

    private static final String SQL_GET_ALL =
            "SELECT " +
            "    c.ContractID, " +
            "    c.EmployeeID, " +
            "    e.FullName, " +
            "    d.DeptName, " +
            "    c.StartDate, " +
            "    c.EndDate, " +
            "    c.BaseSalary, " +
            "    c.Allowance, " +
            "    c.ContractType, " +
            "    c.Notes, " +
            "    c.CreatedAt, " +
            "    c.Status " +
            "FROM Contract c " +
            "JOIN Employee e ON c.EmployeeID = e.EmployeeID " +
            "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
            "ORDER BY c.CreatedAt DESC";

    private static final String SQL_GET_BY_ID =
            "SELECT " +
            "    c.ContractID, " +
            "    c.EmployeeID, " +
            "    e.FullName, " +
            "    d.DeptName, " +
            "    c.StartDate, " +
            "    c.EndDate, " +
            "    c.BaseSalary, " +
            "    c.Allowance, " +
            "    c.ContractType, " +
            "    c.Notes, " +
            "    c.CreatedAt, " +
            "    c.Status " +
            "FROM Contract c " +
            "JOIN Employee e ON c.EmployeeID = e.EmployeeID " +
            "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
            "WHERE c.ContractID = ?";

    // ── Public interface methods ─────────────────────────────────────────────

    @Override
    public List<Contract> getAllContracts() {
        List<Contract> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching contract list", ex);
        }
        return list;
    }

    @Override
    public Contract getContractById(int contractId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BY_ID)) {

            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching contract id=" + contractId, ex);
        }
        return null;
    }

    // ── Row mapper ───────────────────────────────────────────────────────────

    private Contract mapRow(ResultSet rs) throws SQLException {
        Contract c = new Contract();
        c.setContractId(rs.getInt("ContractID"));
        c.setEmployeeId(rs.getInt("EmployeeID"));
        c.setEmployeeName(rs.getString("FullName"));
        c.setDepartmentName(rs.getString("DeptName")); // LEFT JOIN — may be null

        java.sql.Date startDate = rs.getDate("StartDate");
        if (startDate != null) c.setStartDate(startDate.toLocalDate());

        java.sql.Date endDate = rs.getDate("EndDate");
        if (endDate != null) c.setEndDate(endDate.toLocalDate());

        c.setBaseSalary(rs.getBigDecimal("BaseSalary"));
        c.setAllowance(rs.getBigDecimal("Allowance"));
        c.setContractType(rs.getString("ContractType"));
        c.setNotes(rs.getString("Notes"));

        java.sql.Date createdAt = rs.getDate("CreatedAt");
        if (createdAt != null) c.setCreatedAt(createdAt.toLocalDate());

        c.setStatus(rs.getString("Status"));
        return c;
    }
}
