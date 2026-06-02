package controller.model;

import java.math.BigDecimal;

public class EmployeeAllowance {
    private int id;
    private int employeeId;
    private int allowanceTypeId;
    private BigDecimal amount;
    private String month;

    public EmployeeAllowance() {}

    public EmployeeAllowance(int id, int employeeId, int allowanceTypeId, BigDecimal amount, String month) {
        this.id = id;
        this.employeeId = employeeId;
        this.allowanceTypeId = allowanceTypeId;
        this.amount = amount;
        this.month = month;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public int getAllowanceTypeId() {
        return allowanceTypeId;
    }

    public void setAllowanceTypeId(int allowanceTypeId) {
        this.allowanceTypeId = allowanceTypeId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    @Override
    public String toString() {
        return "EmployeeAllowance{" +
                "id=" + id +
                ", employeeId=" + employeeId +
                ", allowanceTypeId=" + allowanceTypeId +
                ", amount=" + amount +
                ", month=" + month +
                '}';
    }
}
