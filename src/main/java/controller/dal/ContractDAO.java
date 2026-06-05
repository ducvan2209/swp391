package controller.dal;

import controller.model.Contract;
import java.util.List;

/**
 * DAO interface for Contract persistence operations.
 */
public interface ContractDAO {

    /**
     * Returns all contracts joined with employee name and department,
     * ordered by creation date descending.
     */
    List<Contract> getAllContracts();

    /**
     * Returns a single contract by its ID (with employee + department data),
     * or null if not found.
     */
    Contract getContractById(int contractId);
}
