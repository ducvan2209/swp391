package controller.model;

import java.time.LocalDateTime;

public class Recruitment {
    private int recruitmentId;
    private String jobTitle;
    private String jobDescription;
    private String requirement;
    private String location;
    private double salary;
    private String status;
    private LocalDateTime postedDate;
    private int applicant;

    public Recruitment() {}

    public Recruitment(
            int recruitmentId,
            String jobTitle,
            String jobDescription,
            String requirement,
            String location,
            double salary,
            String status,
            LocalDateTime postedDate,
            int applicant
    ) {
        this.recruitmentId = recruitmentId;
        this.jobTitle = jobTitle;
        this.jobDescription = jobDescription;
        this.requirement = requirement;
        this.location = location;
        this.salary = salary;
        this.status = status;
        this.postedDate = postedDate;
        this.applicant = applicant;
    }

    public int getRecruitmentId() {
        return recruitmentId;
    }

    public void setRecruitmentId(int recruitmentId) {
        this.recruitmentId = recruitmentId;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getJobDescription() {
        return jobDescription;
    }

    public void setJobDescription(String jobDescription) {
        this.jobDescription = jobDescription;
    }

    public String getRequirement() {
        return requirement;
    }

    public void setRequirement(String requirement) {
        this.requirement = requirement;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(LocalDateTime postedDate) {
        this.postedDate = postedDate;
    }

    public int getApplicant() {
        return applicant;
    }

    public void setApplicant(int applicant) {
        this.applicant = applicant;
    }

    @Override
    public String toString() {
        return "Recruitment{" +
                "recruitmentId=" + recruitmentId +
                ", jobTitle=" + jobTitle +
                ", location=" + location +
                ", salary=" + salary +
                ", status=" + status +
                ", postedDate=" + postedDate +
                ", applicant=" + applicant +
                '}';
    }
}
