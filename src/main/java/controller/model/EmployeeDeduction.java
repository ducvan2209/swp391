package controller.model;

import java.math.BigDecimal;

public class EmployeeDeduction {
    private int id;
    private int employeeId;
    private int deductionTypeId;
    private BigDecimal amount;
    private String month;

    public EmployeeDeduction() {}

    public EmployeeDeduction(int id, int employeeId, int deductionTypeId, BigDecimal amount, String month) {
        this.id = id;
        this.employeeId = employeeId;
        this.deductionTypeId = deductionTypeId;
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

    public int getDeductionTypeId() {
        return deductionTypeId;
    }

    public void setDeductionTypeId(int deductionTypeId) {
        this.deductionTypeId = deductionTypeId;
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
        return "EmployeeDeduction{" +
                "id=" + id +
                ", employeeId=" + employeeId +
                ", deductionTypeId=" + deductionTypeId +
                ", amount=" + amount +
                ", month=" + month +
                '}';
    }
}
