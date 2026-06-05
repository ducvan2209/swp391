package controller.HrStaff;

import controller.model.Employee;
import controller.service.EmployeeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/employee/detail")
public class EmployeeDetailServlet extends HttpServlet {

    private final EmployeeService employeeService = new EmployeeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // ── Validate id param ────────────────────────────────────
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing employee ID.");
            request.getRequestDispatcher("/Views/HrStaff/employee-detail.jsp")
                   .forward(request, response);
            return;
        }

        int employeeId;
        try {
            employeeId = Integer.parseInt(idParam.trim());
            if (employeeId <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid employee ID: " + idParam);
            request.getRequestDispatcher("/Views/HrStaff/employee-detail.jsp")
                   .forward(request, response);
            return;
        }

        // ── Fetch from service ───────────────────────────────────
        Employee employee = employeeService.getEmployeeDetail(employeeId);

        // employee may be null — JSP handles the "not found" display
        request.setAttribute("employee", employee);
        request.getRequestDispatcher("/Views/HrStaff/employee-detail.jsp")
               .forward(request, response);
    }
}
