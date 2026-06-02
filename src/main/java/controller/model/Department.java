package controller.model;

public class Department {
    private int departmentId;
    private String deptName;
    private Integer deptManagerId;

    public Department() {}

    public Department(int departmentId, String deptName, Integer deptManagerId) {
        this.departmentId = departmentId;
        this.deptName = deptName;
        this.deptManagerId = deptManagerId;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public Integer getDeptManagerId() {
        return deptManagerId;
    }

    public void setDeptManagerId(Integer deptManagerId) {
        this.deptManagerId = deptManagerId;
    }

    @Override
    public String toString() {
        return "Department{" +
                "departmentId=" + departmentId +
                ", deptName=" + deptName +
                ", deptManagerId=" + deptManagerId +
                '}';
    }
}
