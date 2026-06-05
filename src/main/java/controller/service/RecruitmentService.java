package controller.service;

import controller.dal.RecruitmentDAO;
import controller.dal.RecruitmentDAOImpl;
import controller.model.Recruitment;
import java.util.List;

/**
 * Service layer for recruitment business operations.
 * Decouples servlets from DAO implementation details.
 */
public class RecruitmentService {

    private final RecruitmentDAO recruitmentDAO = new RecruitmentDAOImpl();

    /**
     * Returns all recruitment posts.
     */
    public List<Recruitment> getAllRecruitments() {
        return recruitmentDAO.getAllRecruitments();
    }

    /**
     * Returns a recruitment record by its ID, or null if it doesn't exist.
     */
    public Recruitment getRecruitmentById(int id) {
        return recruitmentDAO.getRecruitmentById(id);
    }

    /**
     * Validates and persists a new recruitment posting.
     * Enforces business rules: Status defaults to "New", Applicant defaults to 1.
     *
     * @return true if insertion succeeded, false otherwise.
     * @throws IllegalArgumentException for invalid inputs.
     */
    public boolean createRecruitment(Recruitment recruitment) {
        // Business rule: Status default
        if (recruitment.getStatus() == null || recruitment.getStatus().trim().isEmpty()) {
            recruitment.setStatus("New");
        }
        // Business rule: Applicant default
        if (recruitment.getApplicant() < 1) {
            recruitment.setApplicant(1);
        }
        // Business rule: Salary > 0
        if (recruitment.getSalary() <= 0) {
            throw new IllegalArgumentException("Salary must be greater than 0.");
        }
        return recruitmentDAO.insertRecruitment(recruitment);
    }
}
