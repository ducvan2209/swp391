package controller.DepartmentManager;

import dao.MailRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/department-manager/requests")
public class MailRequestApiServlet extends DepartmentManagerApiSupport {
    private final MailRequestDAO requestDAO = new MailRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Integer id = parseInteger(request.getParameter("id"));
            if (id != null) {
                writeJson(response, requestDAO.findById(id));
                return;
            }

            writeJson(response, requestDAO.findRequests(
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
            int id = parseRequiredId(request, "id");
            String action = request.getParameter("action");
            if (!"approve".equalsIgnoreCase(action) && !"reject".equalsIgnoreCase(action)) {
                writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Unsupported request action.");
                return;
            }

            requestDAO.updateStatus(id, "approve".equalsIgnoreCase(action) ? "Approved" : "Rejected", getManagerEmployeeId(request));
            writeJson(response, requestDAO.findById(id));
        } catch (IllegalArgumentException exception) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, exception.getMessage());
        } catch (SQLException exception) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, exception.getMessage());
        }
    }
}
