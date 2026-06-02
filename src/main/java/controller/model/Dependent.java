package controller.model;

import java.time.LocalDate;

public class Dependent {
    private int dependentId;
    private int employeeId;
    private String fullName;
    private String relationship;
    private LocalDate birthDate;

    public Dependent() {}

    public Dependent(int dependentId, int employeeId, String fullName, String relationship, LocalDate birthDate) {
        this.dependentId = dependentId;
        this.employeeId = employeeId;
        this.fullName = fullName;
        this.relationship = relationship;
        this.birthDate = birthDate;
    }

    public int getDependentId() {
        return dependentId;
    }

    public void setDependentId(int dependentId) {
        this.dependentId = dependentId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRelationship() {
        return relationship;
    }

    public void setRelationship(String relationship) {
        this.relationship = relationship;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    @Override
    public String toString() {
        return "Dependent{" +
                "dependentId=" + dependentId +
                ", employeeId=" + employeeId +
                ", fullName=" + fullName +
                ", relationship=" + relationship +
                ", birthDate=" + birthDate +
                '}';
    }
}
