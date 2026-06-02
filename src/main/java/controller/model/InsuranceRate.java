package controller.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class InsuranceRate {
    private int insuranceId;
    private String type;
    private BigDecimal employeeRate;
    private BigDecimal employerRate;
    private LocalDate effectiveDate;

    public InsuranceRate() {}

    public InsuranceRate(
            int insuranceId,
            String type,
            BigDecimal employeeRate,
            BigDecimal employerRate,
            LocalDate effectiveDate
    ) {
        this.insuranceId = insuranceId;
        this.type = type;
        this.employeeRate = employeeRate;
        this.employerRate = employerRate;
        this.effectiveDate = effectiveDate;
    }

    public int getInsuranceId() {
        return insuranceId;
    }

    public void setInsuranceId(int insuranceId) {
        this.insuranceId = insuranceId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public BigDecimal getEmployeeRate() {
        return employeeRate;
    }

    public void setEmployeeRate(BigDecimal employeeRate) {
        this.employeeRate = employeeRate;
    }

    public BigDecimal getEmployerRate() {
        return employerRate;
    }

    public void setEmployerRate(BigDecimal employerRate) {
        this.employerRate = employerRate;
    }

    public LocalDate getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(LocalDate effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    @Override
    public String toString() {
        return "InsuranceRate{" +
                "insuranceId=" + insuranceId +
                ", type=" + type +
                ", employeeRate=" + employeeRate +
                ", employerRate=" + employerRate +
                ", effectiveDate=" + effectiveDate +
                '}';
    }
}
