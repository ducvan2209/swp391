package controller.DepartmentManager;

import dao.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/department-manager/employees")
public class EmployeeApiServlet extends DepartmentManagerApiSupport {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Integer id = parseInteger(request.getParameter("id"));
            if (id != null) {
                writeJson(response, employeeDAO.findById(id));
                return;
            }

            writeJson(response, employeeDAO.findEmployees(
                    getManagerEmployeeId(request),
                    request.getParameter("q"),
                    request.getParameter("status")
            ));
        } catch (SQLException exception) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, exception.getMessage());
        }
    }
}
