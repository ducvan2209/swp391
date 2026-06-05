package controller.dal;

import controller.model.Department;
import controller.model.Employee;
import java.util.List;

/**
 * DAO interface for Employee persistence operations.
 */
public interface EmployeeDAO {

    /** Returns all employees with their department name (via JOIN). */
    List<Employee> getAllEmployees();

    /** Returns a single employee with department name and latest contract, or null. */
    Employee getEmployeeDetail(int id);

    /**
     * Inserts a new employee row into the Employee table.
     * @return true if exactly one row was inserted.
     */
    boolean createEmployee(Employee employee);

    /** Returns all departments for use in form dropdowns. */
    List<Department> getAllDepartments();
}
