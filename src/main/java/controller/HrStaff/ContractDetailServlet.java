package controller.HrStaff;

import controller.model.Contract;
import controller.service.ContractService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/contract/detail")
public class ContractDetailServlet extends HttpServlet {

    private final ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // ── Validate id param ────────────────────────────────────
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing contract ID.");
            request.getRequestDispatcher("/Views/HrStaff/contract-detail.jsp")
                   .forward(request, response);
            return;
        }

        int contractId;
        try {
            contractId = Integer.parseInt(idParam.trim());
            if (contractId <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid contract ID: " + idParam);
            request.getRequestDispatcher("/Views/HrStaff/contract-detail.jsp")
                   .forward(request, response);
            return;
        }

        Contract contract = contractService.getContractById(contractId);
        request.setAttribute("contract", contract);
        request.getRequestDispatcher("/Views/HrStaff/contract-detail.jsp")
               .forward(request, response);
    }
}
