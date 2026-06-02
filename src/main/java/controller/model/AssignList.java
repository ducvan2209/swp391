package controller.model;

public class AssignList {
    private int id;
    private int taskId;
    private int empId;

    public AssignList() {}

    public AssignList(int id, int taskId, int empId) {
        this.id = id;
        this.taskId = taskId;
        this.empId = empId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getEmpId() {
        return empId;
    }

    public void setEmpId(int empId) {
        this.empId = empId;
    }

    @Override
    public String toString() {
        return "AssignList{" +
                "id=" + id +
                ", taskId=" + taskId +
                ", empId=" + empId +
                '}';
    }
}
