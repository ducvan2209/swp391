package controller.HrStaff;

import controller.model.Contract;
import controller.service.ContractService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/contract-list")
public class ContractServlet extends HttpServlet {

    private final ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Contract> contracts = contractService.getAllContracts();
        request.setAttribute("contracts", contracts);
        request.getRequestDispatcher("Views/HrStaff/contract-list.jsp")
               .forward(request, response);
    }
}
