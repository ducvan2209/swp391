package controller.service;

import controller.dal.EmployeeDAO;
import controller.dal.EmployeeDAOImpl;
import controller.model.Department;
import controller.model.Employee;

import java.util.List;

/**
 * Service layer for employee business operations.
 * Decouples servlets from DAO implementation details.
 */
public class EmployeeService {

    private final EmployeeDAO employeeDAO = new EmployeeDAOImpl();

    /** Returns all employees (used by the list view). */
    public List<Employee> getAllEmployees() {
        return employeeDAO.getAllEmployees();
    }

    /**
     * Returns a fully-populated Employee (basic info + department + latest contract),
     * or null if no employee with the given id exists.
     */
    public Employee getEmployeeDetail(int id) {
        return employeeDAO.getEmployeeDetail(id);
    }

    /**
     * Persists a new Employee to the database.
     * @return true on success.
     */
    public boolean createEmployee(Employee employee) {
        return employeeDAO.createEmployee(employee);
    }

    /** Returns all departments — used to populate the Create form dropdown. */
    public List<Department> getAllDepartments() {
        return employeeDAO.getAllDepartments();
    }
}
