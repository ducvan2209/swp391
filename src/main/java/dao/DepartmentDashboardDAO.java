package dao;

import controller.dal.Dao;
import controller.model.DepartmentDashboard;
import controller.model.DepartmentDashboard.ActivityItem;
import controller.model.DepartmentDashboard.ChartPoint;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class DepartmentDashboardDAO extends Dao {
    public DepartmentDashboard getDashboard(Integer managerEmployeeId) throws SQLException {
        DepartmentDashboard dashboard = new DepartmentDashboard();
        Integer departmentId = findManagedDepartmentId(managerEmployeeId);

        dashboard.setTotalEmployees(countEmployees(departmentId));
        dashboard.setPendingRequests(countPendingRequests(departmentId));
        dashboard.setPendingTasks(countTasksByStatus(departmentId, "Waiting", "In Progress"));
        dashboard.setCompletedTasks(countTasksByStatus(departmentId, "Completed"));
        dashboard.setTaskCompletion(getMonthlyTaskCompletion(departmentId));
        dashboard.setRequestStatistics(getRequestStatistics(departmentId));
        dashboard.setRecentActivities(getRecentActivities(departmentId));
        dashboard.setDeliveryHealth(calculateDeliveryHealth(dashboard.getCompletedTasks(), dashboard.getPendingTasks()));

        return dashboard;
    }

    private Integer findManagedDepartmentId(Integer managerEmployeeId) throws SQLException {
        if (managerEmployeeId == null) {
            return null;
        }

        String sql = "SELECT DepartmentID FROM Department WHERE DeptManagerID = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, managerEmployeeId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("DepartmentID");
                }
            }
        }
        return null;
    }

    private int countEmployees(Integer departmentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Employee WHERE (? IS NULL OR DepartmentID = ?)";
        return count(sql, departmentId, departmentId);
    }

    private int countPendingRequests(Integer departmentId) throws SQLException {
        String sql = "SELECT COUNT(*) "
                + "FROM MailRequest mr "
                + "JOIN Employee e ON mr.EmployeeID = e.EmployeeID "
                + "WHERE mr.Status = 'Pending' AND (? IS NULL OR e.DepartmentID = ?)";
        return count(sql, departmentId, departmentId);
    }

    private int countTasksByStatus(Integer departmentId, String... statuses) throws SQLException {
        String placeholders = String.join(",", java.util.Collections.nCopies(statuses.length, "?"));
        String sql = "SELECT COUNT(DISTINCT t.TaskID) "
                + "FROM Task t "
                + "LEFT JOIN assignList al ON t.TaskID = al.TaskId "
                + "LEFT JOIN Employee e ON al.EmpId = e.EmployeeID "
                + "WHERE t.Status IN (" + placeholders + ") "
                + "AND (? IS NULL OR e.DepartmentID = ? OR t.AssignedBy IN ("
                + "SELECT DeptManagerID FROM Department WHERE DepartmentID = ?"
                + "))";

        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            int index = 1;
            for (String status : statuses) {
                statement.setString(index++, status);
            }
            setNullableInt(statement, index++, departmentId);
            setNullableInt(statement, index++, departmentId);
            setNullableInt(statement, index, departmentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt(1) : 0;
            }
        }
    }

    private List<ChartPoint> getMonthlyTaskCompletion(Integer departmentId) throws SQLException {
        String sql = "SELECT YEAR(t.DueDate) AS task_year, MONTH(t.DueDate) AS task_month, COUNT(DISTINCT t.TaskID) AS total "
                + "FROM Task t "
                + "LEFT JOIN assignList al ON t.TaskID = al.TaskId "
                + "LEFT JOIN Employee e ON al.EmpId = e.EmployeeID "
                + "WHERE t.Status = 'Completed' "
                + "AND t.DueDate IS NOT NULL "
                + "AND t.DueDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) "
                + "AND (? IS NULL OR e.DepartmentID = ? OR t.AssignedBy IN ("
                + "SELECT DeptManagerID FROM Department WHERE DepartmentID = ?"
                + ")) "
                + "GROUP BY YEAR(t.DueDate), MONTH(t.DueDate) "
                + "ORDER BY task_year, task_month";

        List<ChartPoint> points = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            setNullableInt(statement, 1, departmentId);
            setNullableInt(statement, 2, departmentId);
            setNullableInt(statement, 3, departmentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    int month = resultSet.getInt("task_month");
                    String label = java.time.Month.of(month).getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
                    points.add(new ChartPoint(label, resultSet.getInt("total")));
                }
            }
        }
        return points;
    }

    private List<ChartPoint> getRequestStatistics(Integer departmentId) throws SQLException {
        String sql = "SELECT mr.Status, COUNT(*) AS total "
                + "FROM MailRequest mr "
                + "JOIN Employee e ON mr.EmployeeID = e.EmployeeID "
                + "WHERE (? IS NULL OR e.DepartmentID = ?) "
                + "GROUP BY mr.Status "
                + "ORDER BY FIELD(mr.Status, 'Approved', 'Pending', 'Rejected')";

        List<ChartPoint> points = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            setNullableInt(statement, 1, departmentId);
            setNullableInt(statement, 2, departmentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    points.add(new ChartPoint(resultSet.getString("Status"), resultSet.getInt("total")));
                }
            }
        }
        return points;
    }

    private List<ActivityItem> getRecentActivities(Integer departmentId) throws SQLException {
        List<ActivityItem> activities = new ArrayList<>();
        activities.addAll(getRecentRequestActivities(departmentId));
        activities.addAll(getRecentTaskActivities(departmentId));
        return activities.size() > 6 ? activities.subList(0, 6) : activities;
    }

    private List<ActivityItem> getRecentRequestActivities(Integer departmentId) throws SQLException {
        String sql = "SELECT mr.RequestType, mr.Status, e.FullName, mr.StartDate, mr.EndDate "
                + "FROM MailRequest mr "
                + "JOIN Employee e ON mr.EmployeeID = e.EmployeeID "
                + "WHERE (? IS NULL OR e.DepartmentID = ?) "
                + "ORDER BY mr.RequestID DESC "
                + "LIMIT 3";

        List<ActivityItem> activities = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            setNullableInt(statement, 1, departmentId);
            setNullableInt(statement, 2, departmentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String type = resultSet.getString("RequestType");
                    String employee = resultSet.getString("FullName");
                    Date startDate = resultSet.getDate("StartDate");
                    Date endDate = resultSet.getDate("EndDate");
                    String dateText = startDate == null ? "No date range" : startDate.toString() + (endDate == null ? "" : " to " + endDate);
                    String status = resultSet.getString("Status");
                    activities.add(new ActivityItem(
                            initials(type),
                            type + " request",
                            employee + " submitted " + type.toLowerCase(Locale.ENGLISH) + " request. " + dateText,
                            status,
                            badgeType(status)
                    ));
                }
            }
        }
        return activities;
    }

    private List<ActivityItem> getRecentTaskActivities(Integer departmentId) throws SQLException {
        String sql = "SELECT t.Title, t.Status, COALESCE(e.FullName, manager.FullName) AS FullName "
                + "FROM Task t "
                + "LEFT JOIN assignList al ON t.TaskID = al.TaskId "
                + "LEFT JOIN Employee e ON al.EmpId = e.EmployeeID "
                + "LEFT JOIN Employee manager ON t.AssignedBy = manager.EmployeeID "
                + "WHERE (? IS NULL OR e.DepartmentID = ? OR t.AssignedBy IN ("
                + "SELECT DeptManagerID FROM Department WHERE DepartmentID = ?"
                + ")) "
                + "ORDER BY t.TaskID DESC "
                + "LIMIT 3";

        List<ActivityItem> activities = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            setNullableInt(statement, 1, departmentId);
            setNullableInt(statement, 2, departmentId);
            setNullableInt(statement, 3, departmentId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String title = resultSet.getString("Title");
                    String status = resultSet.getString("Status");
                    String employee = resultSet.getString("FullName");
                    activities.add(new ActivityItem(
                            "TK",
                            title,
                            employee + " task status is " + status + ".",
                            status,
                            badgeType(status)
                    ));
                }
            }
        }
        return activities;
    }

    private int count(String sql, Integer... values) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 0; i < values.length; i++) {
                setNullableInt(statement, i + 1, values[i]);
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getInt(1) : 0;
            }
        }
    }

    private int calculateDeliveryHealth(int completedTasks, int pendingTasks) {
        int total = completedTasks + pendingTasks;
        if (total == 0) {
            return 0;
        }
        return Math.round((completedTasks * 100f) / total);
    }

    private void setNullableInt(PreparedStatement statement, int index, Integer value) throws SQLException {
        if (value == null) {
            statement.setNull(index, java.sql.Types.INTEGER);
        } else {
            statement.setInt(index, value);
        }
    }

    private String badgeType(String status) {
        if ("Approved".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) {
            return "success";
        }
        if ("Rejected".equalsIgnoreCase(status)) {
            return "danger";
        }
        if ("In Progress".equalsIgnoreCase(status)) {
            return "progress";
        }
        return "pending";
    }

    private String initials(String value) {
        if (value == null || value.length() < 2) {
            return "RQ";
        }
        return value.substring(0, 2).toUpperCase(Locale.ENGLISH);
    }
}

