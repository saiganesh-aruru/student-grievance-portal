<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Student Dashboard | Grievance &amp; Feedback Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <!-- Authenticated Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="dashboard" />
    </jsp:include>

    <!-- Main Content Area -->
    <div class="main-content">
      <!-- Topbar Header -->
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">Student Dashboard</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/student/submit-grievance" class="btn btn-primary btn-sm">
            <span>+ Lodge Grievance</span>
          </a>
        </div>
      </header>

      <!-- Page Body -->
      <main class="page-container">
        <!-- Action Messages -->
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <!-- Welcome Banner -->
        <div class="card" style="margin-bottom: 2rem; background: linear-gradient(135deg, #0e2a47 0%, #1b3d63 100%); color: #ffffff; border: none;">
          <div class="card-body" style="padding: 1.75rem 2rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: gap;">
            <div>
              <span class="badge badge-info" style="margin-bottom: 0.5rem; background: rgba(56, 189, 248, 0.2); border-color: rgba(56, 189, 248, 0.4); color: #7dd3fc;">Academic Session <%= java.time.Year.now().getValue() %></span>
              <h2 style="color: #ffffff; font-size: 1.55rem; margin-bottom: 0.35rem;">
                Welcome back, <c:out value="${sessionScope.user.fullName}"/>!
              </h2>
              <p style="color: #cbd5e1; font-size: 0.92rem;">
                Department: <strong><c:out value="${sessionScope.user.department != null ? sessionScope.user.department : 'General'}"/></strong> |
                Roll No: <strong><c:out value="${sessionScope.user.studentId}"/></strong>
              </p>
            </div>
            <div style="display: flex; gap: 0.75rem; flex-wrap: wrap; margin-top: 1rem;">
              <a href="${pageContext.request.contextPath}/student/submit-grievance" class="btn btn-primary btn-sm">
                ✍️ Submit Grievance
              </a>
              <a href="${pageContext.request.contextPath}/student/submit-feedback" class="btn btn-teal btn-sm">
                ⭐ Give Feedback
              </a>
            </div>
          </div>
        </div>

        <!-- Metric Cards Grid -->
        <div class="stat-grid">
          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value"><c:out value="${stats.totalGrievances}"/></div>
              <div class="stat-label">Total Submitted</div>
            </div>
            <div class="stat-icon blue">📁</div>
          </div>

          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value"><c:out value="${stats.submittedCount + stats.underReviewCount}"/></div>
              <div class="stat-label">Pending / Review</div>
            </div>
            <div class="stat-icon yellow">⏳</div>
          </div>

          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value"><c:out value="${stats.inProgressCount}"/></div>
              <div class="stat-label">In Progress</div>
            </div>
            <div class="stat-icon purple">⚙️</div>
          </div>

          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value" style="color: var(--success);"><c:out value="${stats.resolvedCount}"/></div>
              <div class="stat-label">Resolved</div>
            </div>
            <div class="stat-icon green">✅</div>
          </div>
        </div>

        <!-- Recent Grievances Table Card -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Recent Submissions</h3>
            <a href="${pageContext.request.contextPath}/student/my-grievances" class="btn btn-outline btn-sm">
              View All Grievances &rarr;
            </a>
          </div>

          <div class="card-body" style="padding: 0;">
            <c:choose>
              <c:when test="${not empty recentGrievances}">
                <div class="table-responsive">
                  <table class="data-table">
                    <thead>
                      <tr>
                        <th>Tracking ID</th>
                        <th>Grievance Title</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Current Status</th>
                        <th>Submission Date</th>
                        <th>Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="item" items="${recentGrievances}">
                        <tr>
                          <td>
                            <strong style="color: var(--accent); font-family: monospace; font-size: 0.95rem;">
                              <c:out value="${item.trackingId}"/>
                            </strong>
                          </td>
                          <td>
                            <div style="font-weight: 600; color: var(--text-main);"><c:out value="${item.title}"/></div>
                            <div style="font-size: 0.8rem; color: var(--text-muted);"><c:out value="${item.department}"/></div>
                          </td>
                          <td><span class="badge badge-muted"><c:out value="${item.category}"/></span></td>
                          <td>
                            <span class="badge ${item.priorityBadgeClass}"><c:out value="${item.priority}"/></span>
                          </td>
                          <td>
                            <span class="badge ${item.statusBadgeClass}"><c:out value="${item.status}"/></span>
                          </td>
                          <td style="font-size: 0.85rem; color: var(--text-muted);">
                            <fmt:formatDate value="${item.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
                          </td>
                          <td>
                            <a href="${pageContext.request.contextPath}/student/grievance-details?id=${item.id}"
                               class="btn btn-outline btn-sm">
                              Track &rarr;
                            </a>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>

              <c:otherwise>
                <div class="empty-state">
                  <div class="empty-icon">📭</div>
                  <h4 class="empty-title">No Grievances Submitted Yet</h4>
                  <p class="empty-desc">
                    You have not registered any grievances. If you are experiencing any academic, faculty, or facility challenges, file your ticket now.
                  </p>
                  <a href="${pageContext.request.contextPath}/student/submit-grievance" class="btn btn-primary">
                    + Lodge First Grievance
                  </a>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

      </main>

      <!-- Footer -->
      <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
  </div>

</body>
</html>
