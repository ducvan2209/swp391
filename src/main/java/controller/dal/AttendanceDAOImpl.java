package controller.dal;

import controller.model.Attendance;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Concrete JDBC implementation of AttendanceDAO.
 */
public class AttendanceDAOImpl implements AttendanceDAO {

    private static final Logger LOGGER = Logger.getLogger(AttendanceDAOImpl.class.getName());

    private static final String SQL_GET_ALL =
            "SELECT " +
            "    a.AttendanceID, " +
            "    e.EmployeeID, " +
            "    e.FullName, " +
            "    d.DeptName, " +
            "    a.Date, " +
            "    a.CheckIn, " +
            "    a.CheckOut, " +
            "    a.WorkingHours, " +
            "    a.OvertimeHours " +
            "FROM Attendance a " +
            "JOIN Employee e ON a.EmployeeID = e.EmployeeID " +
            "LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID " +
            "ORDER BY a.Date DESC";

    @Override
    public List<Attendance> getAllAttendance() {
        List<Attendance> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching attendance list", ex);
        }

        return list;
    }

    // ── Row mapper ───────────────────────────────────────────────────────────

    private Attendance mapRow(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();

        a.setAttendanceId(rs.getInt("AttendanceID"));
        a.setEmployeeId(rs.getInt("EmployeeID"));
        a.setEmployeeName(rs.getString("FullName"));
        a.setDepartmentName(rs.getString("DeptName")); // may be null from LEFT JOIN

        java.sql.Date date = rs.getDate("Date");
        if (date != null) {
            a.setDate(date.toLocalDate());
        }

        Time checkIn = rs.getTime("CheckIn");
        if (checkIn != null) {
            a.setCheckIn(checkIn.toLocalTime());
        }

        Time checkOut = rs.getTime("CheckOut");
        if (checkOut != null) {
            a.setCheckOut(checkOut.toLocalTime());
        }

        a.setWorkingHours(rs.getBigDecimal("WorkingHours"));
        a.setOvertimeHours(rs.getBigDecimal("OvertimeHours"));

        return a;
    }
}
