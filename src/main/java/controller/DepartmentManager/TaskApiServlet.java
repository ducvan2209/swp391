package controller.DepartmentManager;

import controller.model.Task;
import dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/api/department-manager/tasks")
public class TaskApiServlet extends DepartmentManagerApiSupport {
    private final TaskDAO taskDAO = new TaskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Integer id = parseInteger(request.getParameter("id"));
            if (id != null) {
                writeJson(response, taskDAO.findById(id));
                return;
            }

            writeJson(response, taskDAO.findTasks(
                    getManagerEmployeeId(request),
                    request.getParameter("q"),
                    request.getParameter("status")
            ));
        } catch (SQLException exception) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, exception.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String action = request.getParameter("action");
            int id = parseRequiredId(request, "id");
            if ("approve".equalsIgnoreCase(action) || "reject".equalsIgnoreCase(action)) {
                taskDAO.updateStatus(id, "approve".equalsIgnoreCase(action) ? "Completed" : "Rejected");
                writeJson(response, taskDAO.findById(id));
                return;
            }
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Unsupported task action.");
        } catch (IllegalArgumentException exception) {
            createTask(request, response);
        } catch (SQLException exception) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, exception.getMessage());
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Integer managerEmployeeId = getManagerEmployeeId(request);
            int assignedEmployeeId = parseRequiredId(request, "assignedEmployeeId");
            Task task = new Task();
            task.setTitle(request.getParameter("title"));
            task.setDescription(request.getParameter("description"));
            task.setAssignedBy(managerEmployeeId == null ? assignedEmployeeId : managerEmployeeId);
            task.setPriority(request.getParameter("priority"));
            task.setStartDate(parseDate(request.getParameter("startDate")));
            task.setDueDate(parseDate(request.getParameter("dueDate")));
            task.setStatus("Waiting");
            int taskId = taskDAO.create(task, assignedEmployeeId);
            response.setStatus(HttpServletResponse.SC_CREATED);
            writeJson(response, taskDAO.findById(taskId));
        } catch (IllegalArgumentException exception) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, exception.getMessage());
        } catch (SQLException exception) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, exception.getMessage());
        }
    }

    private LocalDate parseDate(String value) {
        return value == null || value.trim().isEmpty() ? null : LocalDate.parse(value);
    }
}
