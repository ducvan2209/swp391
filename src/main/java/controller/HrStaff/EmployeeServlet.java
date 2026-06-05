package controller.HrStaff;

import controller.dal.EmployeeDAOImpl;
import controller.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/employee-list")
public class EmployeeServlet extends HttpServlet {

    private final EmployeeDAOImpl employeeDAO = new EmployeeDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Employee> employees = employeeDAO.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/Views/HrStaff/employee-list.jsp") 
               .forward(request, response);
    }
}
