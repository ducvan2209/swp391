package controller.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

public class Attendance {
    private int attendanceId;
    private int employeeId;
    private String employeeName;
    private String departmentName;
    private LocalDate date;
    private LocalTime checkIn;
    private LocalTime checkOut;
    private BigDecimal workingHours;
    private BigDecimal overtimeHours;

    public Attendance() {}

    public Attendance(
            int attendanceId,
            int employeeId,
            String employeeName,
            String departmentName,
            LocalDate date,
            LocalTime checkIn,
            LocalTime checkOut,
            BigDecimal workingHours,
            BigDecimal overtimeHours
    ) {
        this.attendanceId   = attendanceId;
        this.employeeId     = employeeId;
        this.employeeName   = employeeName;
        this.departmentName = departmentName;
        this.date           = date;
        this.checkIn        = checkIn;
        this.checkOut       = checkOut;
        this.workingHours   = workingHours;
        this.overtimeHours  = overtimeHours;
    }

    public int getAttendanceId() { return attendanceId; }
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }

    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getCheckIn() { return checkIn; }
    public void setCheckIn(LocalTime checkIn) { this.checkIn = checkIn; }

    public LocalTime getCheckOut() { return checkOut; }
    public void setCheckOut(LocalTime checkOut) { this.checkOut = checkOut; }

    public BigDecimal getWorkingHours() { return workingHours; }
    public void setWorkingHours(BigDecimal workingHours) { this.workingHours = workingHours; }

    public BigDecimal getOvertimeHours() { return overtimeHours; }
    public void setOvertimeHours(BigDecimal overtimeHours) { this.overtimeHours = overtimeHours; }

    @Override
    public String toString() {
        return "Attendance{" +
                "attendanceId=" + attendanceId +
                ", employeeId=" + employeeId +
                ", employeeName=" + employeeName +
                ", departmentName=" + departmentName +
                ", date=" + date +
                ", checkIn=" + checkIn +
                ", checkOut=" + checkOut +
                ", workingHours=" + workingHours +
                ", overtimeHours=" + overtimeHours +
                '}';
    }
}
