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
import java.util.List;

@WebServlet("/recruitment/list")
public class RecruitmentListServlet extends HttpServlet {

    private final RecruitmentService recruitmentService = new RecruitmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Recruitment> recruitments = recruitmentService.getAllRecruitments();
        request.setAttribute("recruitments", recruitments);

        // Pass date formatter to format java.time.LocalDateTime in JSP
        request.setAttribute("dateFormatter", DateTimeFormatter.ofPattern("dd-MM-yyyy"));

        // Flash message: ?created=1 sent from CreateRecruitmentServlet after success
        String created = request.getParameter("created");
        if ("1".equals(created)) {
            request.setAttribute("successMessage", "Job posting created successfully!");
        }

        request.getRequestDispatcher("/Views/Recruitment/recruitment-list.jsp")
               .forward(request, response);
    }
}
