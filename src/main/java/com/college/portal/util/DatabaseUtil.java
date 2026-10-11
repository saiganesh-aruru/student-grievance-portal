package com.college.portal.util;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database utility managing JDBC connections with automatic schema creation
 * and seed data initialization on first run.
 */
public class DatabaseUtil {
    private static final Logger LOGGER = Logger.getLogger(DatabaseUtil.class.getName());
    private static final Properties props = new Properties();
    private static boolean mysqlAvailable = false;
    private static boolean fallbackActive = false;
    private static volatile boolean initialized = false;

    static {
        loadConfiguration();
    }

    private static synchronized void loadConfiguration() {
        try (InputStream is = DatabaseUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
            } else {
                props.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                props.setProperty("db.url", "jdbc:mysql://localhost:3306/student_grievance_portal?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8");
                props.setProperty("db.username", "root");
                props.setProperty("db.password", "root");
            }

            try {
                Class.forName(props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver"));
            } catch (ClassNotFoundException ignored) {}

            try {
                Class.forName("org.h2.Driver");
            } catch (ClassNotFoundException ignored) {}

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load database configuration.", e);
        }
    }

    /**
     * Obtains a JDBC database connection.
     * Tries MySQL first; if unavailable, transparently activates embedded JDBC engine.
     */
    public static Connection getConnection() throws SQLException {
        Connection conn;
        if (!fallbackActive) {
            try {
                conn = getMySQLConnection();
                mysqlAvailable = true;
            } catch (SQLException ex) {
                LOGGER.info("MySQL connection unavailable (" + ex.getMessage() + "). Activating zero-config embedded JDBC engine.");
                fallbackActive = true;
                conn = getFallbackConnection();
            }
        } else {
            conn = getFallbackConnection();
        }

        if (!initialized) {
            bootstrapDatabase(conn);
        }

        return conn;
    }

    private static Connection getMySQLConnection() throws SQLException {
        String url = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = System.getProperty("db.url", props.getProperty("db.url"));
        }

        String username = System.getenv("DB_USERNAME");
        if (username == null || username.trim().isEmpty()) {
            username = System.getProperty("db.username", props.getProperty("db.username"));
        }

        String password = System.getenv("DB_PASSWORD");
        if (password == null) {
            password = System.getProperty("db.password", props.getProperty("db.password"));
        }

        return DriverManager.getConnection(url, username, password);
    }

    private static Connection getFallbackConnection() throws SQLException {
        String dbPath = System.getProperty("user.home") + "/.portal_db";
        String h2Url = "jdbc:h2:" + dbPath + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;AUTO_SERVER=TRUE;DB_CLOSE_DELAY=-1";
        return DriverManager.getConnection(h2Url, "sa", "");
    }

    /**
     * Ensures all tables and seed data exist.
     */
    private static synchronized void bootstrapDatabase(Connection conn) {
        if (initialized) return;

        try (Statement stmt = conn.createStatement()) {
            // 1. Create tables
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "full_name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "student_id VARCHAR(30) UNIQUE, " +
                    "password_hash VARCHAR(255) NOT NULL, " +
                    "salt VARCHAR(64) NOT NULL, " +
                    "role VARCHAR(20) NOT NULL DEFAULT 'STUDENT', " +
                    "department VARCHAR(60), " +
                    "phone VARCHAR(20), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            stmt.execute("CREATE TABLE IF NOT EXISTS grievances (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "tracking_id VARCHAR(20) NOT NULL UNIQUE, " +
                    "student_id INT NOT NULL, " +
                    "title VARCHAR(150) NOT NULL, " +
                    "category VARCHAR(50) NOT NULL, " +
                    "priority VARCHAR(20) NOT NULL DEFAULT 'Medium', " +
                    "department VARCHAR(60), " +
                    "description TEXT NOT NULL, " +
                    "status VARCHAR(30) NOT NULL DEFAULT 'Submitted', " +
                    "admin_response TEXT, " +
                    "resolved_by INT, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            stmt.execute("CREATE TABLE IF NOT EXISTS grievance_timeline (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "grievance_id INT NOT NULL, " +
                    "status VARCHAR(30) NOT NULL, " +
                    "remarks TEXT, " +
                    "updated_by INT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            stmt.execute("CREATE TABLE IF NOT EXISTS feedback (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "student_id INT NOT NULL, " +
                    "category VARCHAR(50) NOT NULL, " +
                    "subject VARCHAR(150) NOT NULL, " +
                    "comments TEXT NOT NULL, " +
                    "rating INT NOT NULL, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            // 2. Check if users table is populated
            boolean hasUsers = false;
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users")) {
                if (rs.next() && rs.getInt(1) > 0) {
                    hasUsers = true;
                }
            }

            if (!hasUsers) {
                LOGGER.info("Seeding initial administrator, student, and demonstration records...");
                insertSeedData(stmt);
                LOGGER.info("Initial database seed completed successfully.");
            }

            initialized = true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database bootstrap error: " + e.getMessage(), e);
        }
    }

    private static void insertSeedData(Statement stmt) throws SQLException {
        // Administrator (Password: AdminPassword@123)
        stmt.execute("INSERT INTO users (id, full_name, email, student_id, password_hash, salt, role, department, phone) VALUES (" +
                "1, 'Dr. Sarah Mitchell', 'admin@college.edu', NULL, " +
                "'41ff4ce90d2e3a073f20cd0d867863fccb5c779aa77d5148d169803136c5c6c7', " +
                "'a1b2c3d4e5f6789012345678abcdef01', 'ADMIN', 'Academic Affairs & Grievance Cell', '+91 9876500001')");

        // Students (Password: StudentPassword@123)
        stmt.execute("INSERT INTO users (id, full_name, email, student_id, password_hash, salt, role, department, phone) VALUES (" +
                "2, 'Alex Johnson', 'alex.student@college.edu', 'CS-2023-042', " +
                "'a215d5754b980b7c5dde14b9a710a6f10aea92f262b7703e2b5b1480c08486ec', " +
                "'a1b2c3d4e5f6789012345678abcdef01', 'STUDENT', 'Computer Science & Engineering', '+91 9876543210')");

        stmt.execute("INSERT INTO users (id, full_name, email, student_id, password_hash, salt, role, department, phone) VALUES (" +
                "3, 'Priya Patel', 'priya.patel@college.edu', 'EC-2023-019', " +
                "'a215d5754b980b7c5dde14b9a710a6f10aea92f262b7703e2b5b1480c08486ec', " +
                "'a1b2c3d4e5f6789012345678abcdef01', 'STUDENT', 'Electronics & Communication', '+91 9876543211')");

        // Sample Grievances
        stmt.execute("INSERT INTO grievances (id, tracking_id, student_id, title, category, priority, department, description, status, admin_response, resolved_by) VALUES (" +
                "1, 'GRV-2026-0001', 2, 'Lab Computer System Crashing Frequently in Lab 3', 'Infrastructure', 'High', " +
                "'Computer Science & Engineering', 'During our practical session, multiple workstations in Lab 3 experience random reboots.', " +
                "'In Progress', 'Department technician identified faulty RAM modules. Replacements ordered.', 1)");

        stmt.execute("INSERT INTO grievances (id, tracking_id, student_id, title, category, priority, department, description, status, admin_response, resolved_by) VALUES (" +
                "2, 'GRV-2026-0002', 2, 'Evaluation Discrepancy in Midterm Algorithm Paper', 'Academics', 'Medium', " +
                "'Computer Science & Engineering', 'Totaling mistake of 6 marks in Question 4 of midterm paper.', " +
                "'Resolved', 'Marks amended from 38/50 to 44/50 on exam portal following paper re-verification.', 1)");

        stmt.execute("INSERT INTO grievances (id, tracking_id, student_id, title, category, priority, department, description, status, admin_response, resolved_by) VALUES (" +
                "3, 'GRV-2026-0003', 2, 'Hostel Block B Hot Water Geyser Not Functioning', 'Hostel', 'Urgent', " +
                "'Hostel Office', 'The geyser on 2nd floor of Hostel Block B has stopped working.', " +
                "'Submitted', NULL, NULL)");

        stmt.execute("INSERT INTO grievances (id, tracking_id, student_id, title, category, priority, department, description, status, admin_response, resolved_by) VALUES (" +
                "4, 'GRV-2026-0004', 3, 'Overcrowding in College Bus Route #7', 'Transport', 'Medium', " +
                "'Transport Section', 'Bus route #7 has exceeded safe seating capacity during peak morning hours.', " +
                "'Under Review', 'Transport supervisor scheduling additional shuttle capacity inspection.', 1)");

        // Sample Grievance Timelines
        stmt.execute("INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) VALUES (1, 'Submitted', 'Grievance registered by student.', 2)");
        stmt.execute("INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) VALUES (1, 'In Progress', 'Faulty RAM identified on desks 14-20.', 1)");
        stmt.execute("INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) VALUES (2, 'Submitted', 'Grievance registered by student.', 2)");
        stmt.execute("INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) VALUES (2, 'Resolved', 'Marks amended by committee.', 1)");
        stmt.execute("INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) VALUES (3, 'Submitted', 'Grievance registered by student.', 2)");
        stmt.execute("INSERT INTO grievance_timeline (grievance_id, status, remarks, updated_by) VALUES (4, 'Submitted', 'Grievance registered by student.', 3)");

        // Sample Feedback
        stmt.execute("INSERT INTO feedback (student_id, category, subject, comments, rating) VALUES (" +
                "2, 'Campus Wi-Fi/IT', 'High-Speed Wi-Fi in Central Library', 'Wi-Fi coverage in the central library reading halls has drastically improved.', 5)");
        stmt.execute("INSERT INTO feedback (student_id, category, subject, comments, rating) VALUES (" +
                "2, 'Mess/Canteen', 'Nutritional Diversity in Evening Canteen Menu', 'Food is hygienic, but would appreciate fruit options.', 3)");
        stmt.execute("INSERT INTO feedback (student_id, category, subject, comments, rating) VALUES (" +
                "3, 'Laboratory', 'Microcontroller Lab Oscilloscopes and Equipment', 'Newly inaugurated VLSI lab is very well equipped.', 5)");
    }
}
