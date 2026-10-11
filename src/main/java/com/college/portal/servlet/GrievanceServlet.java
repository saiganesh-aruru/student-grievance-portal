package com.college.portal.servlet;

import com.college.portal.dao.GrievanceDAO;
import com.college.portal.model.Grievance;
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

/**
 * Controller handling all Student and Administrator grievance workflows:
 * submission, filtering, details inspection, and administrative updates.
 */
@WebServlet(name = "GrievanceServlet", urlPatterns = {
        "/student/submit-grievance",
        "/student/my-grievances",
        "/student/grievance-details",
        "/admin/manage-grievances",
        "/admin/grievance-details",
        "/admin/update-grievance"
})
public class GrievanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private GrievanceDAO grievanceDAO;

    @Override
    public void init() throws ServletException {
        this.grievanceDAO = new GrievanceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        switch (path) {
            case "/student/submit-grievance" -> {
                request.getRequestDispatcher("/WEB-INF/views/student/submit-grievance.jsp").forward(request, response);
            }
            case "/student/my-grievances" -> {
                if (currentUser == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }
                String status = request.getParameter("status");
                String category = request.getParameter("category");
                List<Grievance> list = grievanceDAO.findByStudentId(currentUser.getId(), status, category);

                request.setAttribute("grievances", list);
                request.setAttribute("selectedStatus", status);
                request.setAttribute("selectedCategory", category);
                request.getRequestDispatcher("/WEB-INF/views/student/my-grievances.jsp").forward(request, response);
            }
            case "/student/grievance-details" -> {
                handleStudentGrievanceDetails(request, response, currentUser);
            }
            case "/admin/manage-grievances" -> {
                String status = request.getParameter("status");
                String category = request.getParameter("category");
                String priority = request.getParameter("priority");
                String keyword = request.getParameter("keyword");

                List<Grievance> list = grievanceDAO.findAll(status, category, priority, keyword);
                request.setAttribute("grievances", list);
                request.setAttribute("selectedStatus", status);
                request.setAttribute("selectedCategory", category);
                request.setAttribute("selectedPriority", priority);
                request.setAttribute("keyword", keyword);
                request.getRequestDispatcher("/WEB-INF/views/admin/manage-grievances.jsp").forward(request, response);
            }
            case "/admin/grievance-details" -> {
                handleAdminGrievanceDetails(request, response);
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

        // CSRF Token Validation
        if (!CSRFUtil.isValidToken(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF security token.");
            return;
        }

        switch (path) {
            case "/student/submit-grievance" -> handleStudentSubmission(request, response, currentUser);
            case "/admin/update-grievance" -> handleAdminUpdate(request, response, currentUser);
            default -> response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void handleStudentGrievanceDetails(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/student/my-grievances");
            return;
        }

        int grievanceId = Integer.parseInt(idParam);
        Grievance grievance = grievanceDAO.findById(grievanceId);

        if (grievance == null) {
            request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
            return;
        }

        // Strict authorization check: A student can ONLY view their own grievance
        if (currentUser == null || grievance.getStudentId() != currentUser.getId()) {
            request.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(request, response);
            return;
        }

        request.setAttribute("grievance", grievance);
        request.setAttribute("isAdminView", false);
        request.getRequestDispatcher("/WEB-INF/views/student/grievance-details.jsp").forward(request, response);
    }

    private void handleAdminGrievanceDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-grievances");
            return;
        }

        int grievanceId = Integer.parseInt(idParam);
        Grievance grievance = grievanceDAO.findById(grievanceId);

        if (grievance == null) {
            request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
            return;
        }

        request.setAttribute("grievance", grievance);
        request.setAttribute("isAdminView", true);
        request.getRequestDispatcher("/WEB-INF/views/student/grievance-details.jsp").forward(request, response);
    }

    private void handleStudentSubmission(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        if (currentUser == null || !currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String title = ValidationUtil.sanitize(request.getParameter("title"));
        String category = ValidationUtil.sanitize(request.getParameter("category"));
        String priority = ValidationUtil.sanitize(request.getParameter("priority"));
        String department = ValidationUtil.sanitize(request.getParameter("department"));
        String description = ValidationUtil.sanitize(request.getParameter("description"));

        if (!ValidationUtil.isNotEmpty(title) || !ValidationUtil.isValidCategory(category) ||
            !ValidationUtil.isValidPriority(priority) || !ValidationUtil.isNotEmpty(description)) {
            String err = URLEncoder.encode("Please fill in all required grievance fields with valid options.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/student/submit-grievance?error=" + err);
            return;
        }

        if (description.length() < 10) {
            String err = URLEncoder.encode("Please provide a detailed description (minimum 10 characters).", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/student/submit-grievance?error=" + err);
            return;
        }

        Grievance g = new Grievance();
        g.setStudentId(currentUser.getId());
        g.setTitle(title);
        g.setCategory(category);
        g.setPriority(priority);
        g.setDepartment(department.isEmpty() ? currentUser.getDepartment() : department);
        g.setDescription(description);

        boolean success = grievanceDAO.createGrievance(g);
        if (success) {
            String msg = URLEncoder.encode("Grievance registered successfully! Tracking ID: " + g.getTrackingId(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/student/my-grievances?success=" + msg);
        } else {
            String err = URLEncoder.encode("Database error occurred while lodging grievance. Please try again.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/student/submit-grievance?error=" + err);
        }
    }

    private void handleAdminUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        if (currentUser == null || !currentUser.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Administrative privileges required.");
            return;
        }

        String idParam = request.getParameter("grievanceId");
        String status = ValidationUtil.sanitize(request.getParameter("status"));
        String adminResponse = ValidationUtil.sanitize(request.getParameter("adminResponse"));
        String remarks = ValidationUtil.sanitize(request.getParameter("remarks"));
        String assignedDepartment = ValidationUtil.sanitize(request.getParameter("assignedDepartment"));

        if (idParam == null || !idParam.matches("\\d+") || !ValidationUtil.isValidStatus(status)) {
            String err = URLEncoder.encode("Invalid status update parameters submitted.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/admin/manage-grievances?error=" + err);
            return;
        }

        int grievanceId = Integer.parseInt(idParam);
        boolean updated = grievanceDAO.updateStatusAndResponse(
                grievanceId, status, adminResponse, currentUser.getId(), remarks, assignedDepartment
        );

        if (updated) {
            String msg = URLEncoder.encode("Grievance status and official response successfully recorded.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/admin/manage-grievances?success=" + msg);
        } else {
            String err = URLEncoder.encode("Unable to update grievance status in database.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/admin/manage-grievances?error=" + err);
        }
    }
}
