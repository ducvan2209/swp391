package controller.dal;

import controller.model.Guest;
import java.util.List;

/**
 * DAO interface for Guest (Candidate) persistence operations.
 */
public interface GuestDAO {

    /** Returns all guests with their recruitment info (via JOIN). */
    List<Guest> getAllGuests();

    /** Returns a single guest with recruitment info, or null. */
    Guest getGuestDetail(int guestId);
}
