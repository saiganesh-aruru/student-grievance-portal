package com.college.portal.servlet;

import com.college.portal.dao.FeedbackDAO;
import com.college.portal.dao.GrievanceDAO;
import com.college.portal.model.DashboardStats;
import com.college.portal.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

/**
 * Controller providing institutional grievance metrics, category distributions, and analytics for administrators.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private GrievanceDAO grievanceDAO;
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        this.grievanceDAO = new GrievanceDAO();
        this.feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        DashboardStats stats = grievanceDAO.getDashboardStatsForAdmin();
        Map<Integer, Integer> ratingDist = feedbackDAO.getRatingDistribution();

        request.setAttribute("stats", stats);
        request.setAttribute("ratingDistribution", ratingDist);
        request.setAttribute("recentGrievances", stats.getRecentGrievances());

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}
