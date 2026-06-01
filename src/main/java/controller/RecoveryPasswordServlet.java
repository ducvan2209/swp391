package controller;

import dal.EmployeeDAO;
import dal.PasswordResetTokenDAO;
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

public class RecoveryPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/forgetpassword");
            return;
        }

        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        Integer empId = tokenDAO.findEmpIdByValidToken(token);
        if (empId == null) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG21"));
            ViewForward.forward(request, response, "forgetpassword.jsp");
            return;
        }

        request.setAttribute("resetToken", token);
        ViewForward.forward(request, response, "recoverypassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG21"));
            ViewForward.forward(request, response, "forgetpassword.jsp");
            return;
        }

        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        Integer empId = tokenDAO.findEmpIdByValidToken(token);
        if (empId == null) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG21"));
            ViewForward.forward(request, response, "forgetpassword.jsp");
            return;
        }

        if (!PasswordValidator.isStrong(newPassword)) {
            request.setAttribute("errorMessage", PasswordValidator.strengthGuideline());
            request.setAttribute("resetToken", token);
            ViewForward.forward(request, response, "recoverypassword.jsp");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG18"));
            request.setAttribute("resetToken", token);
            ViewForward.forward(request, response, "recoverypassword.jsp");
            return;
        }

        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee employee = employeeDAO.getEmployeeByEmpId(empId);
        if (employee == null) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG20"));
            ViewForward.forward(request, response, "forgetpassword.jsp");
            return;
        }

        boolean updated = employeeDAO.updatePassword(
                employee.getEmpCode(),
                PasswordEncryption.encryptPassword(newPassword));

        if (!updated) {
            request.setAttribute("errorMessage", MessageUtil.get("MSG16"));
            request.setAttribute("resetToken", token);
            ViewForward.forward(request, response, "recoverypassword.jsp");
            return;
        }

        tokenDAO.markTokenUsed(token);
        request.setAttribute("successMessage", MessageUtil.get("MSG22"));
        request.setAttribute("googleAuthUrl", AuthHelper.buildGoogleAuthUrl());
        ViewForward.forward(request, response, "login.jsp");
    }
}
