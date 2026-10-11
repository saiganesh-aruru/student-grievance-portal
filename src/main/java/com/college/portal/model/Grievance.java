package com.college.portal.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model class representing a student grievance submission.
 */
public class Grievance implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String trackingId;
    private int studentId;
    private String studentName;
    private String studentEmail;
    private String studentRollNo;
    private String studentDepartment;
    private String title;
    private String category;
    private String priority;
    private String department;
    private String description;
    private String status;
    private String adminResponse;
    private Integer resolvedBy;
    private String resolverName;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<GrievanceTimeline> timeline = new ArrayList<>();

    public Grievance() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentEmail() {
        return studentEmail;
    }

    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }

    public String getStudentRollNo() {
        return studentRollNo;
    }

    public void setStudentRollNo(String studentRollNo) {
        this.studentRollNo = studentRollNo;
    }

    public String getStudentDepartment() {
        return studentDepartment;
    }

    public void setStudentDepartment(String studentDepartment) {
        this.studentDepartment = studentDepartment;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdminResponse() {
        return adminResponse;
    }

    public void setAdminResponse(String adminResponse) {
        this.adminResponse = adminResponse;
    }

    public Integer getResolvedBy() {
        return resolvedBy;
    }

    public void setResolvedBy(Integer resolvedBy) {
        this.resolvedBy = resolvedBy;
    }

    public String getResolverName() {
        return resolverName;
    }

    public void setResolverName(String resolverName) {
        this.resolverName = resolverName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<GrievanceTimeline> getTimeline() {
        return timeline;
    }

    public void setTimeline(List<GrievanceTimeline> timeline) {
        this.timeline = timeline;
    }

    /**
     * Helper to return badge CSS class based on status
     */
    public String getStatusBadgeClass() {
        if (status == null) return "badge-secondary";
        return switch (status) {
            case "Submitted" -> "badge-info";
            case "Under Review" -> "badge-warning";
            case "In Progress" -> "badge-primary";
            case "Resolved" -> "badge-success";
            case "Rejected" -> "badge-danger";
            default -> "badge-secondary";
        };
    }

    /**
     * Helper to return priority badge CSS class
     */
    public String getPriorityBadgeClass() {
        if (priority == null) return "badge-secondary";
        return switch (priority) {
            case "Low" -> "badge-muted";
            case "Medium" -> "badge-info";
            case "High" -> "badge-warning";
            case "Urgent" -> "badge-danger";
            default -> "badge-secondary";
        };
    }
}
