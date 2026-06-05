package controller.service;

import controller.dal.GuestDAO;
import controller.dal.GuestDAOImpl;
import controller.model.Guest;

import java.util.List;

/**
 * Service layer for Guest (Candidate) business operations.
 * Decouples servlets from DAO implementation details.
 */
public class GuestService {

    private final GuestDAO guestDAO = new GuestDAOImpl();

    /** Returns all guests with recruitment info (used by the list view). */
    public List<Guest> getAllGuests() {
        return guestDAO.getAllGuests();
    }

    /**
     * Returns a fully-populated Guest (basic info + recruitment),
     * or null if no guest with the given id exists.
     */
    public Guest getGuestDetail(int id) {
        return guestDAO.getGuestDetail(id);
    }
}
