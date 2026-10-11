package com.college.portal.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Model class encapsulating aggregated dashboard metrics for students and administrators.
 */
public class DashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalGrievances;
    private int submittedCount;
    private int underReviewCount;
    private int inProgressCount;
    private int resolvedCount;
    private int rejectedCount;
    private int totalFeedback;
    private double averageRating;
    private Map<String, Integer> categoryDistribution = new HashMap<>();
    private List<Grievance> recentGrievances;

    public DashboardStats() {
    }

    public int getTotalGrievances() {
        return totalGrievances;
    }

    public void setTotalGrievances(int totalGrievances) {
        this.totalGrievances = totalGrievances;
    }

    public int getSubmittedCount() {
        return submittedCount;
    }

    public void setSubmittedCount(int submittedCount) {
        this.submittedCount = submittedCount;
    }

    public int getUnderReviewCount() {
        return underReviewCount;
    }

    public void setUnderReviewCount(int underReviewCount) {
        this.underReviewCount = underReviewCount;
    }

    public int getInProgressCount() {
        return inProgressCount;
    }

    public void setInProgressCount(int inProgressCount) {
        this.inProgressCount = inProgressCount;
    }

    public int getResolvedCount() {
        return resolvedCount;
    }

    public void setResolvedCount(int resolvedCount) {
        this.resolvedCount = resolvedCount;
    }

    public int getRejectedCount() {
        return rejectedCount;
    }

    public void setRejectedCount(int rejectedCount) {
        this.rejectedCount = rejectedCount;
    }

    public int getPendingCount() {
        return submittedCount + underReviewCount + inProgressCount;
    }

    public int getTotalFeedback() {
        return totalFeedback;
    }

    public void setTotalFeedback(int totalFeedback) {
        this.totalFeedback = totalFeedback;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public Map<String, Integer> getCategoryDistribution() {
        return categoryDistribution;
    }

    public void setCategoryDistribution(Map<String, Integer> categoryDistribution) {
        this.categoryDistribution = categoryDistribution;
    }

    public List<Grievance> getRecentGrievances() {
        return recentGrievances;
    }

    public void setRecentGrievances(List<Grievance> recentGrievances) {
        this.recentGrievances = recentGrievances;
    }

    public double getResolutionRate() {
        if (totalGrievances == 0) return 0.0;
        return Math.round((double) resolvedCount / totalGrievances * 1000.0) / 10.0;
    }
}
