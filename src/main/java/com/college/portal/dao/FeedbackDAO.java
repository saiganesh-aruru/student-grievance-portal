package com.college.portal.dao;

import com.college.portal.model.Feedback;
import com.college.portal.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for College Facility and Service Feedback.
 */
public class FeedbackDAO {
    private static final Logger LOGGER = Logger.getLogger(FeedbackDAO.class.getName());

    /**
     * Inserts a new feedback submission into the database.
     */
    public boolean createFeedback(Feedback fb) {
        String sql = "INSERT INTO feedback (student_id, category, subject, comments, rating) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, fb.getStudentId());
            ps.setString(2, fb.getCategory());
            ps.setString(3, fb.getSubject());
            ps.setString(4, fb.getComments());
            ps.setInt(5, fb.getRating());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        fb.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating feedback for student ID: " + fb.getStudentId(), e);
        }
        return false;
    }

    /**
     * Retrieves all feedback submitted by a specific student.
     */
    public List<Feedback> findByStudentId(int studentId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name AS student_name, u.student_id AS student_roll_no, u.department AS student_dept " +
                     "FROM feedback f " +
                     "JOIN users u ON f.student_id = u.id " +
                     "WHERE f.student_id = ? " +
                     "ORDER BY f.created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFeedback(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding feedback by student ID: " + studentId, e);
        }
        return list;
    }

    /**
     * Retrieves all feedback records for administrators with category and rating filters.
     */
    public List<Feedback> findAll(String category, Integer rating) {
        List<Feedback> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT f.*, u.full_name AS student_name, u.student_id AS student_roll_no, u.department AS student_dept " +
                "FROM feedback f " +
                "JOIN users u ON f.student_id = u.id " +
                "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("AND f.category = ? ");
            params.add(category.trim());
        }

        if (rating != null && rating >= 1 && rating <= 5) {
            sql.append("AND f.rating = ? ");
            params.add(rating);
        }

        sql.append("ORDER BY f.created_at DESC");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToFeedback(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving feedback list.", e);
        }
        return list;
    }

    /**
     * Computes rating frequency distribution (1-star through 5-stars).
     */
    public Map<Integer, Integer> getRatingDistribution() {
        Map<Integer, Integer> dist = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            dist.put(i, 0);
        }

        String sql = "SELECT rating, COUNT(*) AS cnt FROM feedback GROUP BY rating";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                dist.put(rs.getInt("rating"), rs.getInt("cnt"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting rating distribution.", e);
        }
        return dist;
    }

    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback fb = new Feedback();
        fb.setId(rs.getInt("id"));
        fb.setStudentId(rs.getInt("student_id"));
        fb.setCategory(rs.getString("category"));
        fb.setSubject(rs.getString("subject"));
        fb.setComments(rs.getString("comments"));
        fb.setRating(rs.getInt("rating"));
        fb.setCreatedAt(rs.getTimestamp("created_at"));

        try {
            fb.setStudentName(rs.getString("student_name"));
            fb.setStudentRollNo(rs.getString("student_roll_no"));
            fb.setStudentDepartment(rs.getString("student_dept"));
        } catch (SQLException ignored) {
        }
        return fb;
    }
}
