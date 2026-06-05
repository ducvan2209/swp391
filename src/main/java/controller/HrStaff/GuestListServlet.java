package controller.HrStaff;

import controller.model.Guest;
import controller.service.GuestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/guest-list")
public class GuestListServlet extends HttpServlet {

    private final GuestService guestService = new GuestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Guest> guests = guestService.getAllGuests();
        request.setAttribute("guests", guests);
        request.getRequestDispatcher("/Views/HrStaff/guest-list.jsp")
               .forward(request, response);
    }
}
