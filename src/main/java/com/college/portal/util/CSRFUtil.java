package com.college.portal.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.UUID;

/**
 * Utility for Cross-Site Request Forgery (CSRF) token generation and validation.
 */
public class CSRFUtil {
    public static final String CSRF_SESSION_ATTR = "csrfToken";
    public static final String CSRF_PARAM_NAME = "csrfToken";
    public static final String CSRF_HEADER_NAME = "X-CSRF-TOKEN";

    /**
     * Retrieves the existing CSRF token from the session, or generates a new one.
     */
    public static String getToken(HttpSession session) {
        if (session == null) {
            return "";
        }
        String token = (String) session.getAttribute(CSRF_SESSION_ATTR);
        if (token == null || token.trim().isEmpty()) {
            token = UUID.randomUUID().toString();
            session.setAttribute(CSRF_SESSION_ATTR, token);
        }
        return token;
    }

    /**
     * Regenerates a new CSRF token in the session.
     */
    public static String refreshToken(HttpSession session) {
        if (session == null) {
            return "";
        }
        String token = UUID.randomUUID().toString();
        session.setAttribute(CSRF_SESSION_ATTR, token);
        return token;
    }

    /**
     * Validates that the submitted CSRF token matches the session token.
     */
    public static boolean isValidToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_SESSION_ATTR);
        if (sessionToken == null || sessionToken.isEmpty()) {
            return false;
        }

        String submittedToken = request.getParameter(CSRF_PARAM_NAME);
        if (submittedToken == null || submittedToken.isEmpty()) {
            submittedToken = request.getHeader(CSRF_HEADER_NAME);
        }

        return sessionToken.equals(submittedToken);
    }
}
