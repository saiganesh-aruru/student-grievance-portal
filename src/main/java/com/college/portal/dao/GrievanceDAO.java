package com.college.portal.dao;

import com.college.portal.model.DashboardStats;
import com.college.portal.model.Grievance;
import com.college.portal.model.GrievanceTimeline;
import com.college.portal.util.DatabaseUtil;

import java.sql.*;
import java.time.Year;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Grievance management and resolution timeline.
 */
public class GrievanceDAO {
    private static final Logger LOGGER = Logger.getLogger(GrievanceDAO.class.getName());

    /**
     * Creates a new grievance along with an initial timeline log inside a transaction.
     */
    public boolean createGrievance(Grievance g) {
        String insertGrievanceSql = "INSERT INTO grievances (tracking_id, student_id, title, category, priority, department, description, status) " +
                                    "VALUES (?, ?, ?, ?, ?, ?, ?, 'Submitted')";
        String insertTimelineSql = "INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) " +
                                   "VALUES (?, 'Submitted', ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);

            // Generate unique tracking ID
            String trackingId = generateTrackingId(conn);
            g.setTrackingId(trackingId);

            try (PreparedStatement psG = conn.prepareStatement(insertGrievanceSql, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psT = conn.prepareStatement(insertTimelineSql)) {

                psG.setString(1, g.getTrackingId());
                psG.setInt(2, g.getStudentId());
                psG.setString(3, g.getTitle());
                psG.setString(4, g.getCategory());
                psG.setString(5, g.getPriority());
                psG.setString(6, g.getDepartment());
                psG.setString(7, g.getDescription());

                int affected = psG.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }

                int grievanceId;
                try (ResultSet rs = psG.getGeneratedKeys()) {
                    if (rs.next()) {
                        grievanceId = rs.getInt(1);
                        g.setId(grievanceId);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }

                // Insert initial timeline entry
                psT.setInt(1, grievanceId);
                psT.setString(2, "Grievance submitted by student.");
                psT.setInt(3, g.getStudentId());
                psT.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Transaction rollback during grievance creation.", ex);
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during grievance creation.", e);
            return false;
        }
    }

    /**
     * Generates a unique tracking ID format: GRV-YYYY-XXXX
     */
    private String generateTrackingId(Connection conn) throws SQLException {
        int currentYear = Year.now().getValue();
        String prefix = "GRV-" + currentYear + "-";
        String sql = "SELECT COUNT(*) FROM grievances WHERE tracking_id LIKE ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                int nextNum = 1;
                if (rs.next()) {
                    nextNum = rs.getInt(1) + 1;
                }
                return String.format("%s%04d", prefix, nextNum);
            }
        }
    }

    /**
     * Finds a grievance by ID, including student details and its lifecycle timeline.
     */
    public Grievance findById(int id) {
        String sql = "SELECT g.*, u.full_name AS student_name, u.email AS student_email, " +
                     "u.student_id AS student_roll_no, u.department AS student_dept, " +
                     "r.full_name AS resolver_name " +
                     "FROM grievances g " +
                     "JOIN users u ON g.student_id = u.id " +
                     "LEFT JOIN users r ON g.resolved_by = r.id " +
                     "WHERE g.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Grievance g = mapResultSetToGrievance(rs);
                    g.setTimeline(getTimelineByGrievanceId(conn, id));
                    return g;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding grievance by ID: " + id, e);
        }
        return null;
    }

    /**
     * Retrieves grievances for a specific student with optional status/category filtering.
     */
    public List<Grievance> findByStudentId(int studentId, String status, String category) {
        List<Grievance> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT g.*, u.full_name AS student_name, u.email AS student_email, " +
                "u.student_id AS student_roll_no, u.department AS student_dept, " +
                "r.full_name AS resolver_name " +
                "FROM grievances g " +
                "JOIN users u ON g.student_id = u.id " +
                "LEFT JOIN users r ON g.resolved_by = r.id " +
                "WHERE g.student_id = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(studentId);

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND g.status = ? ");
            params.add(status.trim());
        }

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("AND g.category = ? ");
            params.add(category.trim());
        }

        sql.append("ORDER BY g.created_at DESC");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToGrievance(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listing grievances for student ID: " + studentId, e);
        }
        return list;
    }

    /**
     * Retrieves grievances for administrators with comprehensive filtering and keyword search.
     */
    public List<Grievance> findAll(String status, String category, String priority, String keyword) {
        List<Grievance> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT g.*, u.full_name AS student_name, u.email AS student_email, " +
                "u.student_id AS student_roll_no, u.department AS student_dept, " +
                "r.full_name AS resolver_name " +
                "FROM grievances g " +
                "JOIN users u ON g.student_id = u.id " +
                "LEFT JOIN users r ON g.resolved_by = r.id " +
                "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND g.status = ? ");
            params.add(status.trim());
        }

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("AND g.category = ? ");
            params.add(category.trim());
        }

        if (priority != null && !priority.trim().isEmpty() && !"ALL".equalsIgnoreCase(priority)) {
            sql.append("AND g.priority = ? ");
            params.add(priority.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (g.title LIKE ? OR g.tracking_id LIKE ? OR g.description LIKE ? OR u.full_name LIKE ? OR u.student_id LIKE ?) ");
            String kwParam = "%" + keyword.trim() + "%";
            params.add(kwParam);
            params.add(kwParam);
            params.add(kwParam);
            params.add(kwParam);
            params.add(kwParam);
        }

        sql.append("ORDER BY g.created_at DESC");

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToGrievance(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching all grievances.", e);
        }
        return list;
    }

    /**
     * Updates grievance status, admin response, and writes a timeline entry.
     */
    public boolean updateStatusAndResponse(int grievanceId, String newStatus, String adminResponse,
                                           int adminId, String remarks, String assignedDepartment) {
        String updateSql = "UPDATE grievances SET status = ?, admin_response = ?, resolved_by = ?, " +
                           "department = COALESCE(?, department), updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        String insertTimelineSql = "INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) " +
                                   "VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psU = conn.prepareStatement(updateSql);
                 PreparedStatement psT = conn.prepareStatement(insertTimelineSql)) {

                psU.setString(1, newStatus);
                psU.setString(2, adminResponse);
                psU.setInt(3, adminId);
                psU.setString(4, assignedDepartment);
                psU.setInt(5, grievanceId);

                int affected = psU.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }

                String timelineRemarks = (remarks != null && !remarks.trim().isEmpty())
                        ? remarks
                        : "Status updated to " + newStatus + " by Administrator.";

                psT.setInt(1, grievanceId);
                psT.setString(2, newStatus);
                psT.setString(3, timelineRemarks);
                psT.setInt(4, adminId);
                psT.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException ex) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Transaction rollback during grievance update.", ex);
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during grievance status update: " + grievanceId, e);
            return false;
        }
    }

    /**
     * Gets the lifecycle timeline for a grievance.
     */
    public List<GrievanceTimeline> getTimelineByGrievanceId(int grievanceId) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            return getTimelineByGrievanceId(conn, grievanceId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting timeline for grievance: " + grievanceId, e);
            return Collections.emptyList();
        }
    }

    private List<GrievanceTimeline> getTimelineByGrievanceId(Connection conn, int grievanceId) throws SQLException {
        List<GrievanceTimeline> list = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name AS updater_name " +
                     "FROM grievance_timeline t " +
                     "JOIN users u ON t.updated_by = u.id " +
                     "WHERE t.grievance_id = ? ORDER BY t.created_at ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, grievanceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GrievanceTimeline gt = new GrievanceTimeline();
                    gt.setId(rs.getInt("id"));
                    gt.setGrievanceId(rs.getInt("grievance_id"));
                    gt.setStatus(rs.getString("status"));
                    gt.setRemarks(rs.getString("remarks"));
                    gt.setUpdatedBy(rs.getInt("updated_by"));
                    gt.setUpdaterName(rs.getString("updater_name"));
                    gt.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(gt);
                }
            }
        }
        return list;
    }

    /**
     * Computes dashboard statistics for Administrator view.
     */
    public DashboardStats getDashboardStatsForAdmin() {
        DashboardStats stats = new DashboardStats();
        String countSql = "SELECT status, COUNT(*) AS cnt FROM grievances GROUP BY status";
        String categorySql = "SELECT category, COUNT(*) AS cnt FROM grievances GROUP BY category";
        String feedbackSql = "SELECT COUNT(*) AS total_fb, COALESCE(AVG(rating), 0) AS avg_rating FROM feedback";

        try (Connection conn = DatabaseUtil.getConnection()) {
            // Grievance status counts
            try (PreparedStatement ps = conn.prepareStatement(countSql);
                 ResultSet rs = ps.executeQuery()) {
                int total = 0;
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    total += cnt;
                    switch (status) {
                        case "Submitted" -> stats.setSubmittedCount(cnt);
                        case "Under Review" -> stats.setUnderReviewCount(cnt);
                        case "In Progress" -> stats.setInProgressCount(cnt);
                        case "Resolved" -> stats.setResolvedCount(cnt);
                        case "Rejected" -> stats.setRejectedCount(cnt);
                    }
                }
                stats.setTotalGrievances(total);
            }

            // Grievance category counts
            try (PreparedStatement ps = conn.prepareStatement(categorySql);
                 ResultSet rs = ps.executeQuery()) {
                Map<String, Integer> catMap = new HashMap<>();
                while (rs.next()) {
                    catMap.put(rs.getString("category"), rs.getInt("cnt"));
                }
                stats.setCategoryDistribution(catMap);
            }

            // Feedback summary
            try (PreparedStatement ps = conn.prepareStatement(feedbackSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalFeedback(rs.getInt("total_fb"));
                    stats.setAverageRating(Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0);
                }
            }

            // Recent 5 grievances
            stats.setRecentGrievances(findAll(null, null, null, null).stream().limit(5).toList());

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error computing admin dashboard stats.", e);
        }
        return stats;
    }

    /**
     * Computes dashboard statistics for a specific Student.
     */
    public DashboardStats getDashboardStatsForStudent(int studentId) {
        DashboardStats stats = new DashboardStats();
        String countSql = "SELECT status, COUNT(*) AS cnt FROM grievances WHERE student_id = ? GROUP BY status";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(countSql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                int total = 0;
                while (rs.next()) {
                    String status = rs.getString("status");
                    int cnt = rs.getInt("cnt");
                    total += cnt;
                    switch (status) {
                        case "Submitted" -> stats.setSubmittedCount(cnt);
                        case "Under Review" -> stats.setUnderReviewCount(cnt);
                        case "In Progress" -> stats.setInProgressCount(cnt);
                        case "Resolved" -> stats.setResolvedCount(cnt);
                        case "Rejected" -> stats.setRejectedCount(cnt);
                    }
                }
                stats.setTotalGrievances(total);
            }

            stats.setRecentGrievances(findByStudentId(studentId, null, null).stream().limit(5).toList());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error computing student dashboard stats for ID: " + studentId, e);
        }
        return stats;
    }

    private Grievance mapResultSetToGrievance(ResultSet rs) throws SQLException {
        Grievance g = new Grievance();
        g.setId(rs.getInt("id"));
        g.setTrackingId(rs.getString("tracking_id"));
        g.setStudentId(rs.getInt("student_id"));
        g.setTitle(rs.getString("title"));
        g.setCategory(rs.getString("category"));
        g.setPriority(rs.getString("priority"));
        g.setDepartment(rs.getString("department"));
        g.setDescription(rs.getString("description"));
        g.setStatus(rs.getString("status"));
        g.setAdminResponse(rs.getString("admin_response"));

        int resolverId = rs.getInt("resolved_by");
        if (!rs.wasNull()) {
            g.setResolvedBy(resolverId);
        }

        g.setCreatedAt(rs.getTimestamp("created_at"));
        g.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Joined fields
        try {
            g.setStudentName(rs.getString("student_name"));
            g.setStudentEmail(rs.getString("student_email"));
            g.setStudentRollNo(rs.getString("student_roll_no"));
            g.setStudentDepartment(rs.getString("student_dept"));
            g.setResolverName(rs.getString("resolver_name"));
        } catch (SQLException ignored) {
            // Optional columns if query doesn't join
        }
        return g;
    }
}
