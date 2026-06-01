package helper;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public final class ViewForward {

    private static final String VIEW_DIR = "/WEB-INF/views/";

    private ViewForward() {
    }

    public static void forward(HttpServletRequest request, HttpServletResponse response, String viewName)
            throws ServletException, IOException {
        String path = VIEW_DIR + viewName;
        ServletContext context = request.getServletContext();
        RequestDispatcher dispatcher = context.getRequestDispatcher(path);
        if (dispatcher == null) {
            throw new ServletException("Cannot find view: " + path
                    + ". Redeploy the WAR from target/swp391.war after mvn clean package.");
        }
        dispatcher.forward(request, response);
    }
}
