package dao;

import controller.dal.Dao;
import controller.model.Task;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO extends Dao {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    public List<Task> findTasks(Integer managerEmployeeId, String keyword, String status) throws SQLException {
        Integer departmentId = employeeDAO.findDepartmentIdByManager(managerEmployeeId);
        String sql = "SELECT DISTINCT t.*, e.EmployeeID AS AssignedEmployeeID, e.FullName AS AssignedEmployeeName "
                + "FROM Task t "
                + "LEFT JOIN assignList al ON t.TaskID = al.TaskId "
                + "LEFT JOIN Employee e ON al.EmpId = e.EmployeeID "
                + "WHERE (? IS NULL OR e.DepartmentID = ? OR t.AssignedBy = ?) "
                + "AND (? IS NULL OR t.Status = ?) "
                + "AND (? IS NULL OR t.Title LIKE ? OR e.FullName LIKE ?) "
                + "ORDER BY t.TaskID DESC";

        List<Task> tasks = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            setNullableInt(statement, 1, departmentId);
            setNullableInt(statement, 2, departmentId);
            setNullableInt(statement, 3, managerEmployeeId);
            setNullableString(statement, 4, emptyToNull(status));
            setNullableString(statement, 5, emptyToNull(status));
            String search = toLike(keyword);
            setNullableString(statement, 6, search);
            setNullableString(statement, 7, search);
            setNullableString(statement, 8, search);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    tasks.add(mapTask(resultSet));
                }
            }
        }
        return tasks;
    }

    public Task findById(int taskId) throws SQLException {
        String sql = "SELECT t.*, e.EmployeeID AS AssignedEmployeeID, e.FullName AS AssignedEmployeeName "
                + "FROM Task t "
                + "LEFT JOIN assignList al ON t.TaskID = al.TaskId "
                + "LEFT JOIN Employee e ON al.EmpId = e.EmployeeID "
                + "WHERE t.TaskID = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, taskId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapTask(resultSet) : null;
            }
        }
    }

    public int create(Task task, int assignedEmployeeId) throws SQLException {
        String taskSql = "INSERT INTO Task (Title, Description, AssignedBy, StartDate, DueDate, Status) VALUES (?, ?, ?, ?, ?, ?)";
        String assignSql = "INSERT INTO assignList (TaskId, EmpId) VALUES (?, ?)";
        try (Connection connection = getConnection()) {
            connection.setAutoCommit(false);
            try (PreparedStatement taskStatement = connection.prepareStatement(taskSql, Statement.RETURN_GENERATED_KEYS)) {
                taskStatement.setString(1, task.getTitle());
                taskStatement.setString(2, task.getDescription());
                taskStatement.setInt(3, task.getAssignedBy());
                setNullableDate(taskStatement, 4, task.getStartDate() == null ? null : Date.valueOf(task.getStartDate()));
                setNullableDate(taskStatement, 5, task.getDueDate() == null ? null : Date.valueOf(task.getDueDate()));
                taskStatement.setString(6, task.getStatus() == null ? "Waiting" : task.getStatus());
                taskStatement.executeUpdate();
                try (ResultSet keys = taskStatement.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Unable to read generated TaskID.");
                    }
                    int taskId = keys.getInt(1);
                    try (PreparedStatement assignStatement = connection.prepareStatement(assignSql)) {
                        assignStatement.setInt(1, taskId);
                        assignStatement.setInt(2, assignedEmployeeId);
                        assignStatement.executeUpdate();
                    }
                    connection.commit();
                    return taskId;
                }
            } catch (SQLException exception) {
                connection.rollback();
                throw exception;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public void updateStatus(int taskId, String status) throws SQLException {
        String sql = "UPDATE Task SET Status = ? WHERE TaskID = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setInt(2, taskId);
            statement.executeUpdate();
        }
    }

    private Task mapTask(ResultSet resultSet) throws SQLException {
        Date startDate = resultSet.getDate("StartDate");
        Date dueDate = resultSet.getDate("DueDate");
        Task task = new Task(
                resultSet.getInt("TaskID"),
                resultSet.getString("Title"),
                resultSet.getString("Description"),
                resultSet.getInt("AssignedBy"),
                startDate == null ? null : startDate.toLocalDate(),
                dueDate == null ? null : dueDate.toLocalDate(),
                resultSet.getString("Status")
        );
        task.setAssignedEmployeeId(resultSet.getObject("AssignedEmployeeID") == null ? null : resultSet.getInt("AssignedEmployeeID"));
        task.setAssignedEmployeeName(resultSet.getString("AssignedEmployeeName"));
        task.setPriority("Normal");
        return task;
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

    private void setNullableDate(PreparedStatement statement, int index, Date value) throws SQLException {
        if (value == null) {
            statement.setNull(index, java.sql.Types.DATE);
        } else {
            statement.setDate(index, value);
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
