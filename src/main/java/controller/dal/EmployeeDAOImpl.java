package controller.dal;

import controller.model.Contract;
import controller.model.Department;
import controller.model.Employee;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Concrete JDBC implementation of EmployeeDAO.
 * Uses two separate queries for detail view (no JOIN subquery for Contract).
 */
public class EmployeeDAOImpl implements EmployeeDAO {

    private static final Logger LOGGER = Logger.getLogger(EmployeeDAOImpl.class.getName());

    // ── SQL ──────────────────────────────────────────────────────────────────

    private static final String SQL_GET_ALL =
            "SELECT e.*, d.DeptName " +
            "FROM Employee e " +
            "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID";

    private static final String SQL_GET_BASIC =
            "SELECT e.*, d.DeptName " +
            "FROM Employee e " +
            "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
            "WHERE e.EmployeeID = ?";

    private static final String SQL_GET_LATEST_CONTRACT =
            "SELECT * FROM Contract " +
            "WHERE EmployeeID = ? " +
            "ORDER BY StartDate DESC LIMIT 1";

    private static final String SQL_CREATE_EMPLOYEE =
            "INSERT INTO Employee (FullName, Gender, DOB, Address, Phone, Email, " +
            "EmploymentPeriod, DepartmentID, Status, Position) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_GET_ALL_DEPARTMENTS =
            "SELECT DepartmentID, DeptName FROM Department ORDER BY DeptName";

    // ── Public interface methods ─────────────────────────────────────────────

    @Override
    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToEmployee(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching employee list", ex);
        }
        return list;
    }

    @Override
    public Employee getEmployeeDetail(int id) {
        Employee emp = getEmployeeBasic(id);
        if (emp == null) {
            return null;
        }
        Contract contract = getLatestContract(id);
        emp.setLatestContract(contract); // may be null — handled in JSP
        return emp;
    }

    @Override
    public boolean createEmployee(Employee emp) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_CREATE_EMPLOYEE)) {

            ps.setString(1, emp.getFullName());
            ps.setString(2, emp.getGender());

            if (emp.getDob() != null) {
                ps.setDate(3, java.sql.Date.valueOf(emp.getDob()));
            } else {
                ps.setNull(3, java.sql.Types.DATE);
            }

            ps.setString(4, emp.getAddress());
            ps.setString(5, emp.getPhone());
            ps.setString(6, emp.getEmail());
            ps.setString(7, emp.getEmploymentPeriod());

            if (emp.getDepartmentId() != null) {
                ps.setInt(8, emp.getDepartmentId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            ps.setString(9, emp.getStatus());
            ps.setString(10, emp.getPosition());

            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error creating employee: " + emp.getFullName(), ex);
            return false;
        }
    }

    @Override
    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL_DEPARTMENTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Department dept = new Department();
                dept.setDepartmentId(rs.getInt("DepartmentID"));
                dept.setDeptName(rs.getString("DeptName"));
                list.add(dept);
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching department list", ex);
        }
        return list;
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    /**
     * Query 1: Fetch employee row + department name.
     */
    private Employee getEmployeeBasic(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_BASIC)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToEmployee(rs);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching employee basic info for id=" + id, ex);
        }
        return null;
    }

    /**
     * Query 2: Fetch the single most-recent contract for this employee.
     */
    private Contract getLatestContract(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_LATEST_CONTRACT)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToContract(rs);
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching latest contract for employeeId=" + id, ex);
        }
        return null;
    }

    // ── Row mappers ──────────────────────────────────────────────────────────

    private Employee mapRowToEmployee(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setEmployeeId(rs.getInt("EmployeeID"));
        emp.setFullName(rs.getString("FullName"));
        emp.setGender(rs.getString("Gender"));

        java.sql.Date dobSql = rs.getDate("DOB");
        if (dobSql != null) {
            emp.setDob(dobSql.toLocalDate());
        }

        emp.setAddress(rs.getString("Address"));
        emp.setPhone(rs.getString("Phone"));
        emp.setEmail(rs.getString("Email"));
        emp.setEmploymentPeriod(rs.getString("EmploymentPeriod"));

        int deptId = rs.getInt("DepartmentID");
        if (!rs.wasNull()) {
            emp.setDepartmentId(deptId);
        }

        emp.setStatus(rs.getString("Status"));
        emp.setPosition(rs.getString("Position"));

        // DeptName comes from LEFT JOIN — may be null
        emp.setDepartmentName(rs.getString("DeptName"));

        return emp;
    }

    private Contract mapRowToContract(ResultSet rs) throws SQLException {
        Contract c = new Contract();
        c.setContractId(rs.getInt("ContractID"));
        c.setEmployeeId(rs.getInt("EmployeeID"));

        java.sql.Date startDate = rs.getDate("StartDate");
        if (startDate != null) c.setStartDate(startDate.toLocalDate());

        java.sql.Date endDate = rs.getDate("EndDate");
        if (endDate != null) c.setEndDate(endDate.toLocalDate());

        c.setBaseSalary(rs.getBigDecimal("BaseSalary"));
        c.setAllowance(rs.getBigDecimal("Allowance"));
        c.setContractType(rs.getString("ContractType"));
        c.setNotes(rs.getString("Notes"));
        c.setStatus(rs.getString("Status"));

        java.sql.Date createdAt = rs.getDate("CreatedAt");
        if (createdAt != null) c.setCreatedAt(createdAt.toLocalDate());

        return c;
    }
}
