package controller.dal;

import controller.model.Recruitment;
import java.util.List;

/**
 * DAO interface for Recruitment persistence operations.
 */
public interface RecruitmentDAO {

    /** Inserts a new recruitment record. Returns true if successful. */
    boolean insertRecruitment(Recruitment recruitment);

    /** Returns all recruitments ordered by PostedDate DESC. */
    List<Recruitment> getAllRecruitments();

    /** Returns a single recruitment by ID, or null. */
    Recruitment getRecruitmentById(int id);
}
