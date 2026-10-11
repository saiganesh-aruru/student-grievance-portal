package com.college.portal.servlet;

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

/**
 * Controller loading metrics, status counters, and recent activity for the student dashboard.
 */
@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private GrievanceDAO grievanceDAO;

    @Override
    public void init() throws ServletException {
        this.grievanceDAO = new GrievanceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !user.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        DashboardStats stats = grievanceDAO.getDashboardStatsForStudent(user.getId());
        request.setAttribute("stats", stats);
        request.setAttribute("recentGrievances", stats.getRecentGrievances());

        request.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(request, response);
    }
}
