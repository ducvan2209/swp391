package controller;

import api.EmailUtil;
import dal.EmployeeDAO;
import dal.PasswordResetTokenDAO;
import helper.AuthHelper;
import helper.MessageUtil;
import helper.ViewForward;
import model.Employee;
import java.io.IOException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ForgetPasswordServlet extends HttpServlet {

    private static final int TOKEN_BYTES = 32;
    private static final int TOKEN_HOURS = 24;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object success = session.getAttribute("successMessage");
            if (success != null) {
                request.setAttribute("successMessage", success);
                session.removeAttribute("successMessage");
            }
        }
        ViewForward.forward(request, response, "forgetpassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG20"));
            ViewForward.forward(request, response, "forgetpassword.jsp");
            return;
        }

        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee employee = employeeDAO.getEmployeeByEmailForAuth(email.trim());

        if (employee == null || !employee.isStatus()) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG20"));
            ViewForward.forward(request, response, "forgetpassword.jsp");
            return;
        }

        String token = generateToken();
        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        LocalDateTime expiresAt = LocalDateTime.now().plusHours(TOKEN_HOURS);
        boolean saved = tokenDAO.saveToken(employee.getEmpId(), token, expiresAt);

        if (!saved) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG16"));
            ViewForward.forward(request, response, "forgetpassword.jsp");
            return;
        }

        EmailUtil.sendResetLink(employee.getEmail(), token);
        AuthHelper.logActivity(request, employee.getEmpId(), "FORGOT_PASSWORD", "Reset link requested");

        HttpSession session = request.getSession(true);
        session.setAttribute("successMessage", MessageUtil.get("MSG23"));
        response.sendRedirect(request.getContextPath() + "/forgetpassword");
    }

    private static String generateToken() {
        byte[] bytes = new byte[TOKEN_BYTES];
        new SecureRandom().nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
