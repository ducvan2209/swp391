package controller.DepartmentManager;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

public abstract class DepartmentManagerApiSupport extends HttpServlet {
    protected final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, (com.google.gson.JsonSerializer<LocalDate>) (date, type, context) -> context.serialize(date.toString()))
            .create();

    protected void writeJson(HttpServletResponse response, Object payload) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(gson.toJson(payload));
    }

    protected void writeError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        writeJson(response, new ApiError(message));
    }

    protected Integer getManagerEmployeeId(HttpServletRequest request) {
        return parseInteger(request.getParameter("managerEmployeeId"));
    }

    protected Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    protected int parseRequiredId(HttpServletRequest request, String parameterName) {
        Integer value = parseInteger(request.getParameter(parameterName));
        if (value == null) {
            throw new IllegalArgumentException("Missing or invalid parameter: " + parameterName);
        }
        return value;
    }

    private static class ApiError {
        private final String error;

        ApiError(String error) {
            this.error = error;
        }
    }
}
