package controller.HrStaff;

import controller.model.Department;
import controller.model.Employee;
import controller.service.EmployeeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/employee/create")
public class CreateEmployeeServlet extends HttpServlet {

    private static final String VIEW = "/Views/HrStaff/create-employee.jsp";
    private final EmployeeService employeeService = new EmployeeService();

    // ── GET: show empty form ─────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadDepartments(request);
        request.getRequestDispatcher(VIEW).forward(request, response);
    }

    // ── POST: validate → insert → redirect / re-show form ───────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ── 1. Collect raw inputs ────────────────────────────────────────────
        String fullName        = trim(request.getParameter("fullName"));
        String gender          = trim(request.getParameter("gender"));
        String dobStr          = trim(request.getParameter("dob"));
        String address         = trim(request.getParameter("address"));
        String phone           = trim(request.getParameter("phone"));
        String email           = trim(request.getParameter("email"));
        String employmentPeriod= trim(request.getParameter("employmentPeriod"));
        String departmentIdStr = trim(request.getParameter("departmentId"));
        String status          = trim(request.getParameter("status"));
        String position        = trim(request.getParameter("position"));

        // ── 2. Validate ──────────────────────────────────────────────────────
        Map<String, String> errors = new HashMap<>();

        if (fullName.isEmpty()) {
            errors.put("fullName", "Full name is required.");
        } else if (fullName.length() > 100) {
            errors.put("fullName", "Full name must be ≤ 100 characters.");
        }

        if (gender.isEmpty()) {
            errors.put("gender", "Please select a gender.");
        }

        LocalDate dob = null;
        if (!dobStr.isEmpty()) {
            try {
                dob = LocalDate.parse(dobStr);
                if (dob.isAfter(LocalDate.now())) {
                    errors.put("dob", "Date of birth cannot be in the future.");
                }
            } catch (DateTimeParseException e) {
                errors.put("dob", "Invalid date format.");
            }
        }

        if (phone.isEmpty()) {
            errors.put("phone", "Phone number is required.");
        } else if (!phone.matches("^[0-9+\\-\\s]{7,20}$")) {
            errors.put("phone", "Phone number format is invalid.");
        }

        if (email.isEmpty()) {
            errors.put("email", "Email is required.");
        } else if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            errors.put("email", "Email format is invalid.");
        }

        if (position.isEmpty()) {
            errors.put("position", "Position is required.");
        }

        if (status.isEmpty()) {
            errors.put("status", "Please select a status.");
        }

        // ── 3. Re-show form on validation failure ────────────────────────────
        if (!errors.isEmpty()) {
            loadDepartments(request);
            request.setAttribute("errors", errors);
            // Repopulate fields so user doesn't lose input
            request.setAttribute("formFullName",         fullName);
            request.setAttribute("formGender",           gender);
            request.setAttribute("formDob",              dobStr);
            request.setAttribute("formAddress",          address);
            request.setAttribute("formPhone",            phone);
            request.setAttribute("formEmail",            email);
            request.setAttribute("formEmploymentPeriod", employmentPeriod);
            request.setAttribute("formDepartmentId",     departmentIdStr);
            request.setAttribute("formStatus",           status);
            request.setAttribute("formPosition",         position);
            request.getRequestDispatcher(VIEW).forward(request, response);
            return;
        }

        // ── 4. Build Employee object ─────────────────────────────────────────
        Employee emp = new Employee();
        emp.setFullName(fullName);
        emp.setGender(gender);
        emp.setDob(dob);
        emp.setAddress(address.isEmpty() ? null : address);
        emp.setPhone(phone);
        emp.setEmail(email);
        emp.setEmploymentPeriod(employmentPeriod.isEmpty() ? null : employmentPeriod);
        emp.setStatus(status);
        emp.setPosition(position);

        if (!departmentIdStr.isEmpty()) {
            try {
                emp.setDepartmentId(Integer.parseInt(departmentIdStr));
            } catch (NumberFormatException ignored) { /* leave null */ }
        }

        // ── 5. Persist ───────────────────────────────────────────────────────
        boolean success = employeeService.createEmployee(emp);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/employee-list?created=1");
        } else {
            loadDepartments(request);
            request.setAttribute("globalError", "A database error occurred. Please try again.");
            request.setAttribute("formFullName",         fullName);
            request.setAttribute("formGender",           gender);
            request.setAttribute("formDob",              dobStr);
            request.setAttribute("formAddress",          address);
            request.setAttribute("formPhone",            phone);
            request.setAttribute("formEmail",            email);
            request.setAttribute("formEmploymentPeriod", employmentPeriod);
            request.setAttribute("formDepartmentId",     departmentIdStr);
            request.setAttribute("formStatus",           status);
            request.setAttribute("formPosition",         position);
            request.getRequestDispatcher(VIEW).forward(request, response);
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private void loadDepartments(HttpServletRequest request) {
        List<Department> departments = employeeService.getAllDepartments();
        request.setAttribute("departments", departments);
    }

    private String trim(String value) {
        return (value == null) ? "" : value.trim();
    }
}
