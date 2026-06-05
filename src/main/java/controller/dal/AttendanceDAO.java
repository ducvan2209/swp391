package controller.dal;

import controller.model.Attendance;
import java.util.List;

/**
 * DAO interface for Attendance persistence operations.
 */
public interface AttendanceDAO {

    /**
     * Returns all attendance records joined with employee name and department.
     * Ordered by date descending.
     */
    List<Attendance> getAllAttendance();
}
