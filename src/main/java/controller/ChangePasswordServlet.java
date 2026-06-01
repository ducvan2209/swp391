package controller;

import api.EmailUtil;
import dal.EmployeeDAO;
import helper.AuthHelper;
import helper.MessageUtil;
import helper.PasswordEncryption;
import helper.PasswordValidator;
import helper.ViewForward;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AuthHelper.SESSION_USER) == null) {
            response.sendRedirect(request.getContextPath() + "/login?expired=1");
            return;
        }
        request.setAttribute("passwordGuideline", PasswordValidator.strengthGuideline());
        ViewForward.forward(request, response, "changepassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AuthHelper.SESSION_USER) == null) {
            response.sendRedirect(request.getContextPath() + "/login?expired=1");
            return;
        }

        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee sessionUser = (Employee) session.getAttribute(AuthHelper.SESSION_USER);
        Employee employee = employeeDAO.getEmployeeByEmpCode(sessionUser.getEmpCode());
        if (employee == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login?expired=1");
            return;
        }

        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        if (newPass != null && newPass.equals(currentPass)) {
            forwardWithError(request, response, MessageUtil.get("MSG24"));
            return;
        }
        if (!PasswordEncryption.checkPassword(currentPass, employee.getPassword())) {
            forwardWithError(request, response, MessageUtil.get("MSG17"));
            return;
        }
        if (!PasswordValidator.isStrong(newPass)) {
            forwardWithError(request, response, PasswordValidator.strengthGuideline());
            return;
        }
        if (!newPass.equals(confirmPass)) {
            forwardWithError(request, response, MessageUtil.get("MSG18"));
            return;
        }

        boolean success = employeeDAO.updatePassword(
                employee.getEmpCode(),
                PasswordEncryption.encryptPassword(newPass));

        if (!success) {
            forwardWithError(request, response, MessageUtil.get("MSG16"));
            return;
        }

        Employee refreshed = employeeDAO.refreshEmployeeSession(employee.getEmpCode());
        session.setAttribute(AuthHelper.SESSION_USER, refreshed);
        AuthHelper.logActivity(request, employee.getEmpId(), "CHANGE_PASSWORD", "Password changed by user");
        EmailUtil.sendPasswordChangedNotification(employee.getEmail(), employee.getFullname());

        request.setAttribute("successMessage", MessageUtil.get("MSG15"));
        request.setAttribute("passwordGuideline", PasswordValidator.strengthGuideline());
        ViewForward.forward(request, response, "changepassword.jsp");
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.setAttribute("passwordGuideline", PasswordValidator.strengthGuideline());
        ViewForward.forward(request, response, "changepassword.jsp");
    }
}
