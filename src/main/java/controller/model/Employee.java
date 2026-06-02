package controller.model;

import java.time.LocalDate;

public class Employee {
    private int employeeId;
    private String fullName;
    private String gender;
    private LocalDate dob;
    private String address;
    private String phone;
    private String email;
    private String employmentPeriod;
    private Integer departmentId;
    private String status;
    private String position;

    public Employee() {}

    public Employee(
            int employeeId,
            String fullName,
            String gender,
            LocalDate dob,
            String address,
            String phone,
            String email,
            String employmentPeriod,
            Integer departmentId,
            String status,
            String position
    ) {
        this.employeeId = employeeId;
        this.fullName = fullName;
        this.gender = gender;
        this.dob = dob;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.employmentPeriod = employmentPeriod;
        this.departmentId = departmentId;
        this.status = status;
        this.position = position;
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmploymentPeriod() {
        return employmentPeriod;
    }

    public void setEmploymentPeriod(String employmentPeriod) {
        this.employmentPeriod = employmentPeriod;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "employeeId=" + employeeId +
                ", fullName=" + fullName +
                ", gender=" + gender +
                ", dob=" + dob +
                ", address=" + address +
                ", phone=" + phone +
                ", email=" + email +
                ", employmentPeriod=" + employmentPeriod +
                ", departmentId=" + departmentId +
                ", status=" + status +
                ", position=" + position +
                '}';
    }
}
