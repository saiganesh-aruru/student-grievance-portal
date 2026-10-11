package com.college.portal.servlet;

import com.college.portal.dao.FeedbackDAO;
import com.college.portal.model.Feedback;
import com.college.portal.model.User;
import com.college.portal.util.CSRFUtil;
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
import java.util.List;
import java.util.Map;

/**
 * Controller handling facility feedback submission, student personal reviews, and admin review panels.
 */
@WebServlet(name = "FeedbackServlet", urlPatterns = {
        "/student/submit-feedback",
        "/student/my-feedback",
        "/admin/manage-feedback"
})
public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        this.feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        switch (path) {
            case "/student/submit-feedback" -> {
                request.getRequestDispatcher("/WEB-INF/views/student/submit-feedback.jsp").forward(request, response);
            }
            case "/student/my-feedback" -> {
                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }
                List<Feedback> list = feedbackDAO.findByStudentId(currentUser.getId());
                request.setAttribute("feedbackList", list);
                request.getRequestDispatcher("/WEB-INF/views/student/my-feedback.jsp").forward(request, response);
            }
            case "/admin/manage-feedback" -> {
                String category = request.getParameter("category");
                String ratingStr = request.getParameter("rating");
                Integer rating = null;
                if (ratingStr != null && ratingStr.matches("[1-5]")) {
                    rating = Integer.parseInt(ratingStr);
                }

                List<Feedback> list = feedbackDAO.findAll(category, rating);
                Map<Integer, Integer> distribution = feedbackDAO.getRatingDistribution();

                request.setAttribute("feedbackList", list);
                request.setAttribute("selectedCategory", category);
                request.setAttribute("selectedRating", rating);
                request.setAttribute("ratingDistribution", distribution);
                request.getRequestDispatcher("/WEB-INF/views/admin/manage-feedback.jsp").forward(request, response);
            }
            default -> response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (!CSRFUtil.isValidToken(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or expired CSRF token.");
            return;
        }

        if ("/student/submit-feedback".equals(path)) {
            if (currentUser == null || !currentUser.isStudent()) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String category = ValidationUtil.sanitize(request.getParameter("category"));
            String subject = ValidationUtil.sanitize(request.getParameter("subject"));
            String comments = ValidationUtil.sanitize(request.getParameter("comments"));
            String ratingStr = request.getParameter("rating");

            int rating = 0;
            try {
                if (ratingStr != null) {
                    rating = Integer.parseInt(ratingStr);
                }
            } catch (NumberFormatException ignored) {}

            if (!ValidationUtil.isValidFeedbackCategory(category) || !ValidationUtil.isNotEmpty(subject) ||
                !ValidationUtil.isNotEmpty(comments) || !ValidationUtil.isValidRating(rating)) {
                String err = URLEncoder.encode("Please provide all required feedback details, including a 1 to 5 star rating.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/student/submit-feedback?error=" + err);
                return;
            }

            Feedback fb = new Feedback(currentUser.getId(), category, subject, comments, rating);
            boolean created = feedbackDAO.createFeedback(fb);

            if (created) {
                String msg = URLEncoder.encode("Thank you for your valuable feedback! It has been recorded for administration review.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/student/my-feedback?success=" + msg);
            } else {
                String err = URLEncoder.encode("Database error occurred while submitting feedback. Please try again.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/student/submit-feedback?error=" + err);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
