package helper;

import dal.ActivityLogDAO;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Employee;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public final class AuthHelper {

    public static final String SESSION_USER = "user";
    public static final String REMEMBER_EMAIL_COOKIE = "rememberEmail";

    private AuthHelper() {
    }

    public static void logActivity(HttpServletRequest request, Integer empId, String action, String details) {
        String ip = request.getRemoteAddr();
        new ActivityLogDAO().insert(empId, action, ip, details);
    }

    public static void establishSession(HttpServletRequest request, Employee employee) {
        HttpSession session = request.getSession(true);
        session.setAttribute(SESSION_USER, employee);
    }

    /** Task 1: all roles land on dashboard until role-specific modules are added. */
    public static String resolveHomeUrl(Employee employee) {
        return "dashboard";
    }

    public static void rememberEmail(HttpServletResponse response, String email, boolean remember) {
        Cookie cookie = new Cookie(REMEMBER_EMAIL_COOKIE, remember && email != null ? email : "");
        cookie.setMaxAge(remember && email != null ? 7 * 24 * 60 * 60 : 0);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }

    public static void clearRememberEmail(HttpServletResponse response) {
        rememberEmail(response, null, false);
    }

    public static String readRememberedEmail(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }
        for (Cookie cookie : cookies) {
            if (REMEMBER_EMAIL_COOKIE.equals(cookie.getName()) && !cookie.getValue().isEmpty()) {
                return cookie.getValue();
            }
        }
        return null;
    }

    public static String buildGoogleAuthUrl() {
        String clientId = KeyLoader.get("google.client.id");
        String redirectUri = KeyLoader.get("google.redirect.uri");
        if (clientId == null || redirectUri == null) {
            return null;
        }
        try {
            return "https://accounts.google.com/o/oauth2/auth"
                    + "?scope=" + URLEncoder.encode("email profile openid", StandardCharsets.UTF_8.name())
                    + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8.name())
                    + "&response_type=code"
                    + "&client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8.name())
                    + "&access_type=offline&prompt=consent";
        } catch (UnsupportedEncodingException e) {
            return null;
        }
    }
}
