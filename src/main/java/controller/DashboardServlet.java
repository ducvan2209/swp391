package controller;

import helper.AuthHelper;
import helper.ViewForward;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Employee user = session == null ? null : (Employee) session.getAttribute(AuthHelper.SESSION_USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?expired=1");
            return;
        }
        request.setAttribute("user", user);
        ViewForward.forward(request, response, "home.jsp");
    }
}
