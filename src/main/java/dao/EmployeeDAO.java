package dao;

import controller.dal.Dao;
import controller.model.Employee;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO extends Dao {
    public List<Employee> findEmployees(Integer managerEmployeeId, String keyword, String status) throws SQLException {
        Integer departmentId = findDepartmentIdByManager(managerEmployeeId);
        String sql = "SELECT e.* FROM Employee e "
                + "WHERE (? IS NULL OR e.DepartmentID = ?) "
                + "AND (? IS NULL OR e.Status = ?) "
                + "AND (? IS NULL OR e.FullName LIKE ? OR e.Email LIKE ? OR e.Position LIKE ?) "
                + "ORDER BY e.EmployeeID DESC";

        List<Employee> employees = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            setNullableInt(statement, 1, departmentId);
            setNullableInt(statement, 2, departmentId);
            setNullableString(statement, 3, emptyToNull(status));
            setNullableString(statement, 4, emptyToNull(status));
            String search = toLike(keyword);
            setNullableString(statement, 5, search);
            setNullableString(statement, 6, search);
            setNullableString(statement, 7, search);
            setNullableString(statement, 8, search);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    employees.add(mapEmployee(resultSet));
                }
            }
        }
        return employees;
    }

    public Employee findById(int employeeId) throws SQLException {
        String sql = "SELECT * FROM Employee WHERE EmployeeID = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, employeeId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapEmployee(resultSet) : null;
            }
        }
    }

    public Integer findDepartmentIdByManager(Integer managerEmployeeId) throws SQLException {
        if (managerEmployeeId == null) {
            return null;
        }
        String sql = "SELECT DepartmentID FROM Department WHERE DeptManagerID = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, managerEmployeeId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt("DepartmentID") : null;
            }
        }
    }

    private Employee mapEmployee(ResultSet resultSet) throws SQLException {
        Date dob = resultSet.getDate("DOB");
        Integer departmentId = resultSet.getObject("DepartmentID") == null ? null : resultSet.getInt("DepartmentID");
        return new Employee(
                resultSet.getInt("EmployeeID"),
                resultSet.getString("FullName"),
                resultSet.getString("Gender"),
                dob == null ? null : dob.toLocalDate(),
                resultSet.getString("Address"),
                resultSet.getString("Phone"),
                resultSet.getString("Email"),
                resultSet.getString("EmploymentPeriod"),
                departmentId,
                resultSet.getString("Status"),
                resultSet.getString("Position")
        );
    }

    private void setNullableInt(PreparedStatement statement, int index, Integer value) throws SQLException {
        if (value == null) {
            statement.setNull(index, java.sql.Types.INTEGER);
        } else {
            statement.setInt(index, value);
        }
    }

    private void setNullableString(PreparedStatement statement, int index, String value) throws SQLException {
        if (value == null) {
            statement.setNull(index, java.sql.Types.VARCHAR);
        } else {
            statement.setString(index, value);
        }
    }

    private String emptyToNull(String value) {
        return value == null || value.trim().isEmpty() || "All".equalsIgnoreCase(value) ? null : value.trim();
    }

    private String toLike(String value) {
        String cleaned = emptyToNull(value);
        return cleaned == null ? null : "%" + cleaned + "%";
    }
}
