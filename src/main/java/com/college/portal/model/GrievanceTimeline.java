package com.college.portal.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model class representing a point in the grievance resolution lifecycle.
 */
public class GrievanceTimeline implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int grievanceId;
    private String status;
    private String remarks;
    private int updatedBy;
    private String updaterName;
    private Timestamp createdAt;

    public GrievanceTimeline() {
    }

    public GrievanceTimeline(int grievanceId, String status, String remarks, int updatedBy) {
        this.grievanceId = grievanceId;
        this.status = status;
        this.remarks = remarks;
        this.updatedBy = updatedBy;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getGrievanceId() {
        return grievanceId;
    }

    public void setGrievanceId(int grievanceId) {
        this.grievanceId = grievanceId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }

    public String getUpdaterName() {
        return updaterName;
    }

    public void setUpdaterName(String updaterName) {
        this.updaterName = updaterName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
