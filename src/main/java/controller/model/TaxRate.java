package controller.model;

import java.math.BigDecimal;

public class TaxRate {
    private int bracketId;
    private BigDecimal incomeMin;
    private BigDecimal incomeMax;
    private BigDecimal rate;
    private BigDecimal deduction;

    public TaxRate() {}

    public TaxRate(int bracketId, BigDecimal incomeMin, BigDecimal incomeMax, BigDecimal rate, BigDecimal deduction) {
        this.bracketId = bracketId;
        this.incomeMin = incomeMin;
        this.incomeMax = incomeMax;
        this.rate = rate;
        this.deduction = deduction;
    }

    public int getBracketId() {
        return bracketId;
    }

    public void setBracketId(int bracketId) {
        this.bracketId = bracketId;
    }

    public BigDecimal getIncomeMin() {
        return incomeMin;
    }

    public void setIncomeMin(BigDecimal incomeMin) {
        this.incomeMin = incomeMin;
    }

    public BigDecimal getIncomeMax() {
        return incomeMax;
    }

    public void setIncomeMax(BigDecimal incomeMax) {
        this.incomeMax = incomeMax;
    }

    public BigDecimal getRate() {
        return rate;
    }

    public void setRate(BigDecimal rate) {
        this.rate = rate;
    }

    public BigDecimal getDeduction() {
        return deduction;
    }

    public void setDeduction(BigDecimal deduction) {
        this.deduction = deduction;
    }

    @Override
    public String toString() {
        return "TaxRate{" +
                "bracketId=" + bracketId +
                ", incomeMin=" + incomeMin +
                ", incomeMax=" + incomeMax +
                ", rate=" + rate +
                ", deduction=" + deduction +
                '}';
    }
}
