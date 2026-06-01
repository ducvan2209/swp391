package controller;

import helper.AuthHelper;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogOutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AuthHelper.SESSION_USER) == null) {
            response.sendRedirect(request.getContextPath() + "/login?expired=1");
            return;
        }

        Employee user = (Employee) session.getAttribute(AuthHelper.SESSION_USER);
        AuthHelper.logActivity(request, user.getEmpId(), "LOGOUT", "User initiated logout");

        session.invalidate();
        clearAuthCookies(response);
        response.sendRedirect(request.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void clearAuthCookies(HttpServletResponse response) {
        AuthHelper.clearRememberEmail(response);
        expireCookie(response, "rememberUser");
        expireCookie(response, "rememberPass");
    }

    private void expireCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
