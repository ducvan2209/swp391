package controller.service;

import controller.dal.AttendanceDAO;
import controller.dal.AttendanceDAOImpl;
import controller.model.Attendance;

import java.util.List;

/**
 * Service layer for attendance business operations.
 */
public class AttendanceService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAOImpl();

    /**
     * Returns all attendance records with employee and department data.
     */
    public List<Attendance> getAllAttendance() {
        return attendanceDAO.getAllAttendance();
    }
}
