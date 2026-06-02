package controller.model;

public class AllowanceType {
    private int allowanceTypeId;
    private String allowanceName;
    private String description;

    public AllowanceType() {}

    public AllowanceType(int allowanceTypeId, String allowanceName, String description) {
        this.allowanceTypeId = allowanceTypeId;
        this.allowanceName = allowanceName;
        this.description = description;
    }

    public int getAllowanceTypeId() {
        return allowanceTypeId;
    }

    public void setAllowanceTypeId(int allowanceTypeId) {
        this.allowanceTypeId = allowanceTypeId;
    }

    public String getAllowanceName() {
        return allowanceName;
    }

    public void setAllowanceName(String allowanceName) {
        this.allowanceName = allowanceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "AllowanceType{" +
                "allowanceTypeId=" + allowanceTypeId +
                ", allowanceName=" + allowanceName +
                '}';
    }
}
