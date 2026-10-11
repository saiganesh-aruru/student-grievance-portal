package com.college.portal.filter;

import com.college.portal.model.User;
import com.college.portal.util.CSRFUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter enforcing session-based role authorization for protected student and administrator endpoints.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/student/*", "/admin/*", "/profile/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Ensure CSRF token is available on active sessions
        if (session != null) {
            CSRFUtil.getToken(session);
        }

        // Student route protection
        if (path.startsWith("/student/")) {
            if (currentUser == null) {
                httpResponse.sendRedirect(contextPath + "/login.jsp?error=Please+log+in+to+access+the+student+portal.");
                return;
            }
            if (!currentUser.isStudent()) {
                httpRequest.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
                return;
            }
        }

        // Administrator route protection
        if (path.startsWith("/admin/")) {
            if (currentUser == null) {
                httpResponse.sendRedirect(contextPath + "/admin-login.jsp?error=Please+log+in+with+administrator+credentials.");
                return;
            }
            if (!currentUser.isAdmin()) {
                httpRequest.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
                return;
            }
        }

        // General profile route protection
        if (path.startsWith("/profile")) {
            if (currentUser == null) {
                httpResponse.sendRedirect(contextPath + "/login.jsp?error=Please+log+in+to+view+your+profile.");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
