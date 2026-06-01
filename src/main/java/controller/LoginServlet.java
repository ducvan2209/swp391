package controller;

import api.GoogleLogin;
import dal.EmployeeDAO;
import helper.AuthHelper;
import helper.MessageUtil;
import helper.PasswordEncryption;
import helper.ViewForward;
import model.Employee;
import model.GoogleAccount;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LoginServlet extends HttpServlet {

    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final int LOCK_MINUTES = 30;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String expired = request.getParameter("expired");
        if ("1".equals(expired)) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG14"));
        }

        String rememberedEmail = AuthHelper.readRememberedEmail(request);
        if (rememberedEmail != null) {
            request.setAttribute("rememberEmail", rememberedEmail);
        }

        request.setAttribute("googleAuthUrl", AuthHelper.buildGoogleAuthUrl());

        String code = request.getParameter("code");
        if (code == null) {
            ViewForward.forward(request, response, "login.jsp");
            return;
        }

        try {
            GoogleAccount googleAcc = GoogleLogin.getUserInfo(GoogleLogin.getToken(code));
            EmployeeDAO employeeDAO = new EmployeeDAO();
            Employee employee = employeeDAO.getEmployeeByEmailForAuth(googleAcc.getEmail());

            if (employee == null) {
                request.setAttribute("errorMessage", MessageUtil.get("MSG09"));
                request.setAttribute("googleAuthUrl", AuthHelper.buildGoogleAuthUrl());
                ViewForward.forward(request, response, "login.jsp");
                return;
            }

            String loginError = validateAccountState(employee);
            if (loginError != null) {
                request.setAttribute("errorMessage", loginError);
                request.setAttribute("googleAuthUrl", AuthHelper.buildGoogleAuthUrl());
                ViewForward.forward(request, response, "login.jsp");
                return;
            }

            employeeDAO.resetFailedLogin(employee.getEmpCode());
            employee.setPassword(null);
            AuthHelper.establishSession(request, employee);
            AuthHelper.logActivity(request, employee.getEmpId(), "LOGIN", "Google OAuth login");
            response.sendRedirect(request.getContextPath() + "/" + AuthHelper.resolveHomeUrl(employee));
        } catch (Exception ex) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG09"));
            request.setAttribute("googleAuthUrl", AuthHelper.buildGoogleAuthUrl());
            ViewForward.forward(request, response, "login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        if (isBlank(email) || isBlank(password)) {
            forwardLogin(request, response, MessageUtil.get("MSG10"), email);
            return;
        }

        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee employee = employeeDAO.getEmployeeByEmailForAuth(email);

        if (employee == null) {
            forwardLogin(request, response, MessageUtil.get("MSG09"), email);
            return;
        }

        String stateError = validateAccountState(employee);
        if (stateError != null) {
            forwardLogin(request, response, stateError, email);
            return;
        }

        if (PasswordEncryption.checkPassword(password, employee.getPassword())) {
            employeeDAO.resetFailedLogin(employee.getEmpCode());
            employee.setPassword(null);
            AuthHelper.establishSession(request, employee);
            AuthHelper.rememberEmail(response, email, "on".equals(remember));
            AuthHelper.logActivity(request, employee.getEmpId(), "LOGIN", "Email/password login");
            response.sendRedirect(request.getContextPath() + "/" + AuthHelper.resolveHomeUrl(employee));
            return;
        }

        handleFailedPassword(employeeDAO, employee);
        forwardLogin(request, response, resolveFailedLoginMessage(employeeDAO, employee), email);
    }

    private void handleFailedPassword(EmployeeDAO employeeDAO, Employee employee) {
        int failed = employee.getFailedLoginCount() + 1;
        Timestamp lockedUntil = null;
        if (failed >= MAX_FAILED_ATTEMPTS) {
            lockedUntil = Timestamp.from(Instant.now().plus(LOCK_MINUTES, ChronoUnit.MINUTES));
            failed = MAX_FAILED_ATTEMPTS;
        }
        employeeDAO.recordFailedLogin(employee.getEmpCode(), failed, lockedUntil);
        employee.setFailedLoginCount(failed);
        employee.setLockedUntil(lockedUntil);
    }

    private String resolveFailedLoginMessage(EmployeeDAO employeeDAO, Employee employee) {
        Employee refreshed = employeeDAO.getEmployeeByEmailForAuth(employee.getEmail());
        if (refreshed != null && isLocked(refreshed)) {
            return MessageUtil.get("MSG13");
        }
        return MessageUtil.get("MSG09");
    }

    private String validateAccountState(Employee employee) {
        if (!employee.isStatus()) {
            return MessageUtil.get("MSG12");
        }
        if (!employee.isEmailVerified()) {
            return MessageUtil.get("MSG11");
        }
        if (isLocked(employee)) {
            return MessageUtil.get("MSG13");
        }
        return null;
    }

    private boolean isLocked(Employee employee) {
        Timestamp lockedUntil = employee.getLockedUntil();
        return lockedUntil != null && lockedUntil.after(new Timestamp(System.currentTimeMillis()));
    }

    private void forwardLogin(HttpServletRequest request, HttpServletResponse response,
            String errorMessage, String email) throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("rememberEmail", email);
        request.setAttribute("googleAuthUrl", AuthHelper.buildGoogleAuthUrl());
        ViewForward.forward(request, response, "login.jsp");
    }

    private static String trim(String value) {
        return value == null ? null : value.trim();
    }

    private static boolean isBlank(String value) {
        return value == null || value.isEmpty();
    }
}
