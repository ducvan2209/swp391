package controller.model;

import java.time.LocalDate;

public class MailRequest {
    private int requestId;
    private int employeeId;
    private String requestType;
    private String leaveType;
    private LocalDate startDate;
    private LocalDate endDate;
    private String reason;
    private String status;
    private Integer approvedBy;

    public MailRequest() {}

    public MailRequest(
            int requestId,
            int employeeId,
            String requestType,
            String leaveType,
            LocalDate startDate,
            LocalDate endDate,
            String reason,
            String status,
            Integer approvedBy
    ) {
        this.requestId = requestId;
        this.employeeId = employeeId;
        this.requestType = requestType;
        this.leaveType = leaveType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.reason = reason;
        this.status = status;
        this.approvedBy = approvedBy;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public String getLeaveType() {
        return leaveType;
    }

    public void setLeaveType(String leaveType) {
        this.leaveType = leaveType;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    @Override
    public String toString() {
        return "MailRequest{" +
                "requestId=" + requestId +
                ", employeeId=" + employeeId +
                ", requestType=" + requestType +
                ", leaveType=" + leaveType +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", status=" + status +
                ", approvedBy=" + approvedBy +
                '}';
    }
}
