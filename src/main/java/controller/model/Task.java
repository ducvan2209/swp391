package controller.model;

import java.time.LocalDate;

public class Task {
    private int taskId;
    private String title;
    private String description;
    private int assignedBy;
    private LocalDate startDate;
    private LocalDate dueDate;
    private String status;
    private Integer assignedEmployeeId;
    private String assignedEmployeeName;
    private String priority;

    public Task() {}

    public Task(
            int taskId,
            String title,
            String description,
            int assignedBy,
            LocalDate startDate,
            LocalDate dueDate,
            String status
    ) {
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.assignedBy = assignedBy;
        this.startDate = startDate;
        this.dueDate = dueDate;
        this.status = status;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getAssignedBy() {
        return assignedBy;
    }

    public void setAssignedBy(int assignedBy) {
        this.assignedBy = assignedBy;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAssignedEmployeeId() {
        return assignedEmployeeId;
    }

    public void setAssignedEmployeeId(Integer assignedEmployeeId) {
        this.assignedEmployeeId = assignedEmployeeId;
    }

    public String getAssignedEmployeeName() {
        return assignedEmployeeName;
    }

    public void setAssignedEmployeeName(String assignedEmployeeName) {
        this.assignedEmployeeName = assignedEmployeeName;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", title=" + title +
                ", assignedBy=" + assignedBy +
                ", startDate=" + startDate +
                ", dueDate=" + dueDate +
                ", status=" + status +
                '}';
    }
}
