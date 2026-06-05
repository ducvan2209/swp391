package controller.HrStaff;

import controller.model.Recruitment;
import controller.service.RecruitmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Handles GET (show create form) and POST (save new recruitment) for /recruitment/create.
 */
@WebServlet("/recruitment/create")
public class CreateRecruitmentServlet extends HttpServlet {

    private final RecruitmentService recruitmentService = new RecruitmentService();

    private static final String CREATE_JSP = "/Views/Recruitment/recruitment-create.jsp";
    private static final String LIST_URL   = "/recruitment/list";

    // ── GET: show empty form ─────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pre-populate default status for the dropdown
        request.setAttribute("selectedStatus", "New");
        request.getRequestDispatcher(CREATE_JSP).forward(request, response);
    }

    // ── POST: validate + save + redirect ────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ── Read parameters ──────────────────────────────────────────────────
        String jobTitle       = trim(request.getParameter("jobTitle"));
        String jobDescription = trim(request.getParameter("jobDescription"));
        String requirement    = trim(request.getParameter("requirement"));
        String location       = trim(request.getParameter("location"));
        String salaryStr      = trim(request.getParameter("salary"));
        String status         = trim(request.getParameter("status"));
        String applicantStr   = trim(request.getParameter("applicant"));

        // ── Server-side validation ───────────────────────────────────────────
        Map<String, String> errors = new HashMap<>();

        if (jobTitle.isEmpty()) {
            errors.put("jobTitle", "Job title is required.");
        }
        if (requirement.isEmpty()) {
            errors.put("requirement", "Requirement is required.");
        }
        if (location.isEmpty()) {
            errors.put("location", "Location is required.");
        }

        double salary = 0;
        if (salaryStr.isEmpty()) {
            errors.put("salary", "Salary is required.");
        } else {
            try {
                salary = Double.parseDouble(salaryStr);
                if (salary <= 0) {
                    errors.put("salary", "Salary must be greater than 0.");
                }
            } catch (NumberFormatException e) {
                errors.put("salary", "Salary must be a valid number.");
            }
        }

        // Validate status against allowed enum values
        java.util.Set<String> validStatuses = new java.util.LinkedHashSet<>(
                java.util.Arrays.asList("New", "Waiting", "Rejected", "Applied", "Deleted"));
        if (status.isEmpty() || !validStatuses.contains(status)) {
            status = "New";
        }

        // ── Return to form with errors if validation failed ──────────────────
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            // Re-populate form values so user doesn't re-type everything
            request.setAttribute("jobTitle",       jobTitle);
            request.setAttribute("jobDescription", jobDescription);
            request.setAttribute("requirement",    requirement);
            request.setAttribute("location",       location);
            request.setAttribute("salaryStr",      salaryStr);
            request.setAttribute("selectedStatus", status);
            request.getRequestDispatcher(CREATE_JSP).forward(request, response);
            return;
        }

        // ── Build model object ───────────────────────────────────────────────
        Recruitment recruitment = new Recruitment();
        recruitment.setJobTitle(jobTitle);
        recruitment.setJobDescription(jobDescription.isEmpty() ? null : jobDescription);
        recruitment.setRequirement(requirement);
        recruitment.setLocation(location);
        recruitment.setSalary(salary);
        recruitment.setStatus(status);

        int applicant = 1;
        try {
            applicant = Integer.parseInt(applicantStr);
            if (applicant < 1) applicant = 1;
        } catch (NumberFormatException ignored) { }
        recruitment.setApplicant(applicant);

        // ── Persist via Service ──────────────────────────────────────────────
        boolean success = recruitmentService.createRecruitment(recruitment);

        if (success) {
            response.sendRedirect(request.getContextPath() + LIST_URL + "?created=1");
        } else {
            request.setAttribute("errorMessage", "Failed to save the job posting. Please try again.");
            request.setAttribute("selectedStatus", status);
            request.getRequestDispatcher(CREATE_JSP).forward(request, response);
        }
    }

    private String trim(String value) {
        return (value == null) ? "" : value.trim();
    }
}
