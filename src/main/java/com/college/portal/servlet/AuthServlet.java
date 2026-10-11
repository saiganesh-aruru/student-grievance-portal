package com.college.portal.servlet;

import com.college.portal.dao.UserDAO;
import com.college.portal.model.User;
import com.college.portal.util.CSRFUtil;
import com.college.portal.util.PasswordUtil;
import com.college.portal.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Controller handling Student and Administrator authentication, registration, and logout.
 */
@WebServlet(name = "AuthServlet", urlPatterns = {
        "/auth/login",
        "/auth/admin-login",
        "/auth/register",
        "/auth/logout"
})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/auth/logout".equals(path)) {
            handleLogout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/auth/login" -> handleStudentLogin(request, response);
            case "/auth/admin-login" -> handleAdminLogin(request, response);
            case "/auth/register" -> handleStudentRegistration(request, response);
            case "/auth/logout" -> handleLogout(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void handleStudentLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String password = request.getParameter("password");

        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(password)) {
            redirectWithError(response, request.getContextPath() + "/login.jsp", "Please provide both email and password.");
            return;
        }

        User user = userDAO.findByEmail(email);
        if (user == null || !user.isStudent() || !PasswordUtil.verifyPassword(password, user.getSalt(), user.getPasswordHash())) {
            redirectWithError(response, request.getContextPath() + "/login.jsp", "Invalid student email or password.");
            return;
        }

        // Establish secure session
        establishSession(request, user);
        response.sendRedirect(request.getContextPath() + "/student/dashboard");
    }

    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String password = request.getParameter("password");

        if (!ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(password)) {
            redirectWithError(response, request.getContextPath() + "/admin-login.jsp", "Please provide both administrator email and password.");
            return;
        }

        User user = userDAO.findByEmail(email);
        if (user == null || !user.isAdmin() || !PasswordUtil.verifyPassword(password, user.getSalt(), user.getPasswordHash())) {
            redirectWithError(response, request.getContextPath() + "/admin-login.jsp", "Invalid administrator credentials or access denied.");
            return;
        }

        // Establish secure session
        establishSession(request, user);
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private void handleStudentRegistration(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Validate CSRF token
        if (!CSRFUtil.isValidToken(request)) {
            redirectWithError(response, request.getContextPath() + "/register.jsp", "Invalid security session. Please refresh and try again.");
            return;
        }

        String fullName = ValidationUtil.sanitize(request.getParameter("fullName"));
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String studentId = ValidationUtil.sanitize(request.getParameter("studentId"));
        String department = ValidationUtil.sanitize(request.getParameter("department"));
        String phone = ValidationUtil.sanitize(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!ValidationUtil.isNotEmpty(fullName) || !ValidationUtil.isValidEmail(email) ||
            !ValidationUtil.isNotEmpty(studentId) || !ValidationUtil.isNotEmpty(password)) {
            redirectWithError(response, request.getContextPath() + "/register.jsp", "Please complete all mandatory fields with valid values.");
            return;
        }

        if (password.length() < 6) {
            redirectWithError(response, request.getContextPath() + "/register.jsp", "Password must be at least 6 characters long.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            redirectWithError(response, request.getContextPath() + "/register.jsp", "Passwords do not match.");
            return;
        }

        if (userDAO.emailExists(email)) {
            redirectWithError(response, request.getContextPath() + "/register.jsp", "An account with this email address already exists.");
            return;
        }

        if (userDAO.studentIdExists(studentId)) {
            redirectWithError(response, request.getContextPath() + "/register.jsp", "A student with this ID / Roll number is already registered.");
            return;
        }

        String salt = PasswordUtil.generateSalt();
        String hash = PasswordUtil.hashPassword(password, salt);

        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setStudentId(studentId);
        newUser.setDepartment(department);
        newUser.setPhone(phone);
        newUser.setSalt(salt);
        newUser.setPasswordHash(hash);

        boolean success = userDAO.registerStudent(newUser);
        if (success) {
            String msg = URLEncoder.encode("Registration successful! You may now log in with your credentials.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/login.jsp?success=" + msg);
        } else {
            redirectWithError(response, request.getContextPath() + "/register.jsp", "An error occurred while creating your account. Please try again.");
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        String msg = URLEncoder.encode("You have logged out successfully.", StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/index.jsp?info=" + msg);
    }

    private void establishSession(HttpServletRequest request, User user) {
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes session timeout
        CSRFUtil.refreshToken(session);
    }

    private void redirectWithError(HttpServletResponse response, String targetUrl, String errorMessage) throws IOException {
        String encoded = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
        response.sendRedirect(targetUrl + "?error=" + encoded);
    }
}
