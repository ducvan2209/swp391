package controller.DepartmentManager;

import dao.DepartmentDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/department-manager/dashboard")
public class DepartmentDashboardApiServlet extends DepartmentManagerApiSupport {
    private final DepartmentDashboardDAO dashboardDAO = new DepartmentDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            writeJson(response, dashboardDAO.getDashboard(getManagerEmployeeId(request)));
        } catch (SQLException exception) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load department dashboard data");
        }
    }
}
