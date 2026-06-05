package controller.service;

import controller.dal.ContractDAO;
import controller.dal.ContractDAOImpl;
import controller.model.Contract;

import java.util.List;

/**
 * Service layer for Contract business operations.
 */
public class ContractService {

    private final ContractDAO contractDAO = new ContractDAOImpl();

    /** Returns all contracts with employee and department data. */
    public List<Contract> getAllContracts() {
        return contractDAO.getAllContracts();
    }

    /**
     * Returns a single contract by ID with employee + department data,
     * or null if not found.
     */
    public Contract getContractById(int contractId) {
        return contractDAO.getContractById(contractId);
    }
}
