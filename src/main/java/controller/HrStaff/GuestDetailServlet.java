package controller.HrStaff;

import controller.model.Guest;
import controller.service.GuestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/guest/detail")
public class GuestDetailServlet extends HttpServlet {

    private final GuestService guestService = new GuestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // ── Validate id param ────────────────────────────────────
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing candidate ID.");
            request.getRequestDispatcher("/Views/HrStaff/guest-detail.jsp")
                   .forward(request, response);
            return;
        }

        int guestId;
        try {
            guestId = Integer.parseInt(idParam.trim());
            if (guestId <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid candidate ID: " + idParam);
            request.getRequestDispatcher("/Views/HrStaff/guest-detail.jsp")
                   .forward(request, response);
            return;
        }

        // ── Fetch from service ───────────────────────────────────
        Guest guest = guestService.getGuestDetail(guestId);

        // guest may be null — JSP handles the "not found" display
        request.setAttribute("guest", guest);
        request.getRequestDispatcher("/Views/HrStaff/guest-detail.jsp")
               .forward(request, response);
    }
}
