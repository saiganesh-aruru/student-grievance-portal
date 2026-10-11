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
 * Controller allowing students and administrators to manage contact information and change passwords.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {
        "/profile",
        "/profile/update",
        "/profile/change-password"
})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Refresh user record from DB
        User refreshed = userDAO.findById(currentUser.getId());
        if (refreshed != null) {
            session.setAttribute("user", refreshed);
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!CSRFUtil.isValidToken(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or expired security token.");
            return;
        }

        if ("/profile/update".equals(path)) {
            handleProfileUpdate(request, response, currentUser);
        } else if ("/profile/change-password".equals(path)) {
            handlePasswordChange(request, response, currentUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        String fullName = ValidationUtil.sanitize(request.getParameter("fullName"));
        String department = ValidationUtil.sanitize(request.getParameter("department"));
        String phone = ValidationUtil.sanitize(request.getParameter("phone"));

        if (!ValidationUtil.isNotEmpty(fullName)) {
            String err = URLEncoder.encode("Full name cannot be empty.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?error=" + err);
            return;
        }

        currentUser.setFullName(fullName);
        currentUser.setDepartment(department);
        currentUser.setPhone(phone);

        boolean updated = userDAO.updateProfile(currentUser);
        if (updated) {
            String msg = URLEncoder.encode("Profile information updated successfully.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?success=" + msg);
        } else {
            String err = URLEncoder.encode("Error updating profile in database.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?error=" + err);
        }
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        User freshUser = userDAO.findById(currentUser.getId());
        if (!PasswordUtil.verifyPassword(currentPassword, freshUser.getSalt(), freshUser.getPasswordHash())) {
            String err = URLEncoder.encode("Current password entered is incorrect.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?error=" + err);
            return;
        }

        if (newPassword == null || newPassword.length() < 6) {
            String err = URLEncoder.encode("New password must be at least 6 characters long.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?error=" + err);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            String err = URLEncoder.encode("New password confirmation does not match.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?error=" + err);
            return;
        }

        String newSalt = PasswordUtil.generateSalt();
        String newHash = PasswordUtil.hashPassword(newPassword, newSalt);

        boolean updated = userDAO.updatePassword(currentUser.getId(), newHash, newSalt);
        if (updated) {
            String msg = URLEncoder.encode("Your password has been changed successfully.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?success=" + msg);
        } else {
            String err = URLEncoder.encode("Database error while updating password.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/profile?error=" + err);
        }
    }
}
