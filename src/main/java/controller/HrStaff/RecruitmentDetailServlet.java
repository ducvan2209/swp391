package controller.HrStaff;

import controller.model.Recruitment;
import controller.service.RecruitmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.format.DateTimeFormatter;

@WebServlet("/recruitment/detail")
public class RecruitmentDetailServlet extends HttpServlet {

    private final RecruitmentService recruitmentService = new RecruitmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // Validate id param
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing recruitment ID.");
            request.getRequestDispatcher("/Views/HrStaff/recruitment-detail.jsp")
                   .forward(request, response);
            return;
        }

        int recruitmentId;
        try {
            recruitmentId = Integer.parseInt(idParam.trim());
            if (recruitmentId <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid recruitment ID: " + idParam);
            request.getRequestDispatcher("/Views/HrStaff/recruitment-detail.jsp")
                   .forward(request, response);
            return;
        }

        // Fetch from service
        Recruitment recruitment = recruitmentService.getRecruitmentById(recruitmentId);

        // recruitment may be null — JSP handles the "not found" display
        request.setAttribute("recruitment", recruitment);

        // Pass date formatter to format java.time.LocalDateTime in JSP
        request.setAttribute("dateFormatter", DateTimeFormatter.ofPattern("dd-MM-yyyy"));

        request.getRequestDispatcher("/Views/HrStaff/recruitment-detail.jsp")
               .forward(request, response);
    }
}
