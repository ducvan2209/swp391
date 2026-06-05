package controller.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Contract {
    private int contractId;
    private int employeeId;
    private String employeeName;
    private String departmentName;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal baseSalary;
    private BigDecimal allowance;
    private String contractType;
    private String notes;
    private LocalDate createdAt;
    private String status;

    public Contract() {}

    public Contract(
            int contractId,
            int employeeId,
            LocalDate startDate,
            LocalDate endDate,
            BigDecimal baseSalary,
            BigDecimal allowance,
            String contractType,
            String notes,
            LocalDate createdAt,
            String status
    ) {
        this.contractId = contractId;
        this.employeeId = employeeId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.baseSalary = baseSalary;
        this.allowance = allowance;
        this.contractType = contractType;
        this.notes = notes;
        this.createdAt = createdAt;
        this.status = status;
    }

    /** Full constructor including joined fields (used by DAO row mapper). */
    public Contract(
            int contractId,
            int employeeId,
            String employeeName,
            String departmentName,
            LocalDate startDate,
            LocalDate endDate,
            BigDecimal baseSalary,
            BigDecimal allowance,
            String contractType,
            String notes,
            LocalDate createdAt,
            String status
    ) {
        this.contractId     = contractId;
        this.employeeId     = employeeId;
        this.employeeName   = employeeName;
        this.departmentName = departmentName;
        this.startDate      = startDate;
        this.endDate        = endDate;
        this.baseSalary     = baseSalary;
        this.allowance      = allowance;
        this.contractType   = contractType;
        this.notes          = notes;
        this.createdAt      = createdAt;
        this.status         = status;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

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

    public BigDecimal getBaseSalary() {
        return baseSalary;
    }

    public void setBaseSalary(BigDecimal baseSalary) {
        this.baseSalary = baseSalary;
    }

    public BigDecimal getAllowance() {
        return allowance;
    }

    public void setAllowance(BigDecimal allowance) {
        this.allowance = allowance;
    }

    public String getContractType() {
        return contractType;
    }

    public void setContractType(String contractType) {
        this.contractType = contractType;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Contract{" +
                "contractId=" + contractId +
                ", employeeId=" + employeeId +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", baseSalary=" + baseSalary +
                ", allowance=" + allowance +
                ", employeeName=" + employeeName +
                ", departmentName=" + departmentName +
                ", contractType=" + contractType +
                ", createdAt=" + createdAt +
                ", status=" + status +
                '}';
    }
}
