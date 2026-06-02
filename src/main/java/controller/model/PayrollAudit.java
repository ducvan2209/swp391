package controller.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PayrollAudit {
    private int auditId;
    private int employeeId;
    private String payPeriod;
    private BigDecimal baseSalary;
    private BigDecimal actualWorkingDays;
    private BigDecimal paidLeaveDays;
    private BigDecimal unpaidLeaveDays;
    private BigDecimal actualBaseSalary;
    private BigDecimal overtimeHours;
    private BigDecimal otSalary;
    private BigDecimal allowance;
    private BigDecimal bhxh;
    private BigDecimal bhyt;
    private BigDecimal bhtn;
    private BigDecimal taxableIncome;
    private BigDecimal personalTax;
    private BigDecimal absentPenalty;
    private BigDecimal otherDeduction;
    private BigDecimal totalDeduction;
    private BigDecimal netSalary;
    private String status;
    private LocalDateTime calculatedAt;
    private Integer calculatedBy;
    private String notes;

    public PayrollAudit() {}

    public PayrollAudit(
            int auditId,
            int employeeId,
            String payPeriod,
            BigDecimal baseSalary,
            BigDecimal actualWorkingDays,
            BigDecimal paidLeaveDays,
            BigDecimal unpaidLeaveDays,
            BigDecimal actualBaseSalary,
            BigDecimal overtimeHours,
            BigDecimal otSalary,
            BigDecimal allowance,
            BigDecimal bhxh,
            BigDecimal bhyt,
            BigDecimal bhtn,
            BigDecimal taxableIncome,
            BigDecimal personalTax,
            BigDecimal absentPenalty,
            BigDecimal otherDeduction,
            BigDecimal totalDeduction,
            BigDecimal netSalary,
            String status,
            LocalDateTime calculatedAt,
            Integer calculatedBy,
            String notes
    ) {
        this.auditId = auditId;
        this.employeeId = employeeId;
        this.payPeriod = payPeriod;
        this.baseSalary = baseSalary;
        this.actualWorkingDays = actualWorkingDays;
        this.paidLeaveDays = paidLeaveDays;
        this.unpaidLeaveDays = unpaidLeaveDays;
        this.actualBaseSalary = actualBaseSalary;
        this.overtimeHours = overtimeHours;
        this.otSalary = otSalary;
        this.allowance = allowance;
        this.bhxh = bhxh;
        this.bhyt = bhyt;
        this.bhtn = bhtn;
        this.taxableIncome = taxableIncome;
        this.personalTax = personalTax;
        this.absentPenalty = absentPenalty;
        this.otherDeduction = otherDeduction;
        this.totalDeduction = totalDeduction;
        this.netSalary = netSalary;
        this.status = status;
        this.calculatedAt = calculatedAt;
        this.calculatedBy = calculatedBy;
        this.notes = notes;
    }

    public int getAuditId() {
        return auditId;
    }

    public void setAuditId(int auditId) {
        this.auditId = auditId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getPayPeriod() {
        return payPeriod;
    }

    public void setPayPeriod(String payPeriod) {
        this.payPeriod = payPeriod;
    }

    public BigDecimal getBaseSalary() {
        return baseSalary;
    }

    public void setBaseSalary(BigDecimal baseSalary) {
        this.baseSalary = baseSalary;
    }

    public BigDecimal getActualWorkingDays() {
        return actualWorkingDays;
    }

    public void setActualWorkingDays(BigDecimal actualWorkingDays) {
        this.actualWorkingDays = actualWorkingDays;
    }

    public BigDecimal getPaidLeaveDays() {
        return paidLeaveDays;
    }

    public void setPaidLeaveDays(BigDecimal paidLeaveDays) {
        this.paidLeaveDays = paidLeaveDays;
    }

    public BigDecimal getUnpaidLeaveDays() {
        return unpaidLeaveDays;
    }

    public void setUnpaidLeaveDays(BigDecimal unpaidLeaveDays) {
        this.unpaidLeaveDays = unpaidLeaveDays;
    }

    public BigDecimal getActualBaseSalary() {
        return actualBaseSalary;
    }

    public void setActualBaseSalary(BigDecimal actualBaseSalary) {
        this.actualBaseSalary = actualBaseSalary;
    }

    public BigDecimal getOvertimeHours() {
        return overtimeHours;
    }

    public void setOvertimeHours(BigDecimal overtimeHours) {
        this.overtimeHours = overtimeHours;
    }

    public BigDecimal getOtSalary() {
        return otSalary;
    }

    public void setOtSalary(BigDecimal otSalary) {
        this.otSalary = otSalary;
    }

    public BigDecimal getAllowance() {
        return allowance;
    }

    public void setAllowance(BigDecimal allowance) {
        this.allowance = allowance;
    }

    public BigDecimal getBhxh() {
        return bhxh;
    }

    public void setBhxh(BigDecimal bhxh) {
        this.bhxh = bhxh;
    }

    public BigDecimal getBhyt() {
        return bhyt;
    }

    public void setBhyt(BigDecimal bhyt) {
        this.bhyt = bhyt;
    }

    public BigDecimal getBhtn() {
        return bhtn;
    }

    public void setBhtn(BigDecimal bhtn) {
        this.bhtn = bhtn;
    }

    public BigDecimal getTaxableIncome() {
        return taxableIncome;
    }

    public void setTaxableIncome(BigDecimal taxableIncome) {
        this.taxableIncome = taxableIncome;
    }

    public BigDecimal getPersonalTax() {
        return personalTax;
    }

    public void setPersonalTax(BigDecimal personalTax) {
        this.personalTax = personalTax;
    }

    public BigDecimal getAbsentPenalty() {
        return absentPenalty;
    }

    public void setAbsentPenalty(BigDecimal absentPenalty) {
        this.absentPenalty = absentPenalty;
    }

    public BigDecimal getOtherDeduction() {
        return otherDeduction;
    }

    public void setOtherDeduction(BigDecimal otherDeduction) {
        this.otherDeduction = otherDeduction;
    }

    public BigDecimal getTotalDeduction() {
        return totalDeduction;
    }

    public void setTotalDeduction(BigDecimal totalDeduction) {
        this.totalDeduction = totalDeduction;
    }

    public BigDecimal getNetSalary() {
        return netSalary;
    }

    public void setNetSalary(BigDecimal netSalary) {
        this.netSalary = netSalary;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCalculatedAt() {
        return calculatedAt;
    }

    public void setCalculatedAt(LocalDateTime calculatedAt) {
        this.calculatedAt = calculatedAt;
    }

    public Integer getCalculatedBy() {
        return calculatedBy;
    }

    public void setCalculatedBy(Integer calculatedBy) {
        this.calculatedBy = calculatedBy;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    @Override
    public String toString() {
        return "PayrollAudit{" +
                "auditId=" + auditId +
                ", employeeId=" + employeeId +
                ", payPeriod=" + payPeriod +
                ", netSalary=" + netSalary +
                ", status=" + status +
                ", calculatedAt=" + calculatedAt +
                ", calculatedBy=" + calculatedBy +
                '}';
    }
}
