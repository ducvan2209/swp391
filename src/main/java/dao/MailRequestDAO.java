package dao;

import controller.dal.Dao;
import controller.model.MailRequest;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MailRequestDAO extends Dao {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    public List<MailRequest> findRequests(Integer managerEmployeeId, String keyword, String status) throws SQLException {
        Integer departmentId = employeeDAO.findDepartmentIdByManager(managerEmployeeId);
        String sql = "SELECT mr.*, e.FullName "
                + "FROM MailRequest mr "
                + "JOIN Employee e ON mr.EmployeeID = e.EmployeeID "
                + "WHERE (? IS NULL OR e.DepartmentID = ?) "
                + "AND (? IS NULL OR mr.Status = ?) "
                + "AND (? IS NULL OR mr.RequestType LIKE ? OR e.FullName LIKE ?) "
                + "ORDER BY mr.RequestID DESC";

        List<MailRequest> requests = new ArrayList<>();
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
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    requests.add(mapRequest(resultSet));
                }
            }
        }
        return requests;
    }

    public MailRequest findById(int requestId) throws SQLException {
        String sql = "SELECT * FROM MailRequest WHERE RequestID = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, requestId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapRequest(resultSet) : null;
            }
        }
    }

    public void updateStatus(int requestId, String status, Integer approvedBy) throws SQLException {
        String sql = "UPDATE MailRequest SET Status = ?, ApprovedBy = ? WHERE RequestID = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            if (approvedBy == null) {
                statement.setNull(2, java.sql.Types.INTEGER);
            } else {
                statement.setInt(2, approvedBy);
            }
            statement.setInt(3, requestId);
            statement.executeUpdate();
        }
    }

    private MailRequest mapRequest(ResultSet resultSet) throws SQLException {
        Date startDate = resultSet.getDate("StartDate");
        Date endDate = resultSet.getDate("EndDate");
        Integer approvedBy = resultSet.getObject("ApprovedBy") == null ? null : resultSet.getInt("ApprovedBy");
        MailRequest request = new MailRequest(
                resultSet.getInt("RequestID"),
                resultSet.getInt("EmployeeID"),
                resultSet.getString("RequestType"),
                resultSet.getString("LeaveType"),
                startDate == null ? null : startDate.toLocalDate(),
                endDate == null ? null : endDate.toLocalDate(),
                resultSet.getString("Reason"),
                resultSet.getString("Status"),
                approvedBy
        );
        try {
            request.setEmployeeName(resultSet.getString("FullName"));
        } catch (SQLException ignored) {
            request.setEmployeeName(null);
        }
        return request;
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
