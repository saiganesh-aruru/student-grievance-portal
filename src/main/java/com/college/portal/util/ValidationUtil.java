package com.college.portal.util;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Utility for server-side input validation, sanitization, and output escaping.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
    );

    public static final List<String> GRIEVANCE_CATEGORIES = Arrays.asList(
            "Academics", "Examinations", "Faculty", "Infrastructure",
            "Hostel", "Transport", "Library", "Other"
    );

    public static final List<String> GRIEVANCE_PRIORITIES = Arrays.asList(
            "Low", "Medium", "High", "Urgent"
    );

    public static final List<String> GRIEVANCE_STATUSES = Arrays.asList(
            "Submitted", "Under Review", "In Progress", "Resolved", "Rejected"
    );

    public static final List<String> FEEDBACK_CATEGORIES = Arrays.asList(
            "Campus Wi-Fi/IT", "Hostel", "Mess/Canteen", "Library",
            "Laboratory", "Sports & Gym", "Transport", "Administration", "Other"
    );

    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim();
    }

    public static boolean isValidCategory(String category) {
        return GRIEVANCE_CATEGORIES.contains(category);
    }

    public static boolean isValidFeedbackCategory(String category) {
        return FEEDBACK_CATEGORIES.contains(category);
    }

    public static boolean isValidPriority(String priority) {
        return GRIEVANCE_PRIORITIES.contains(priority);
    }

    public static boolean isValidStatus(String status) {
        return GRIEVANCE_STATUSES.contains(status);
    }

    public static boolean isValidRating(int rating) {
        return rating >= 1 && rating <= 5;
    }

    /**
     * Escapes critical HTML characters to mitigate Cross-Site Scripting (XSS).
     */
    public static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;");
    }
}
