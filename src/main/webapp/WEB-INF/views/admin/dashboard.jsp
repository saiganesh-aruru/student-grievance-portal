<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
  String csrfToken = com.college.portal.util.CSRFUtil.getToken(session);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Administrator Dashboard | Institutional Redressal Cell</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="dashboard" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">Executive Redressal Overview</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/admin/manage-grievances" class="btn btn-navy btn-sm">
            <span>📑 Manage Grievances</span>
          </a>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <!-- Header Banner -->
        <div class="card" style="margin-bottom: 2rem; background: linear-gradient(135deg, #091e33 0%, #1e1b4b 100%); color: #ffffff; border: none;">
          <div class="card-body" style="padding: 1.75rem 2rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div>
              <span class="badge" style="background: rgba(129, 140, 248, 0.2); border: 1px solid rgba(129, 140, 248, 0.4); color: #c7d2fe; margin-bottom: 0.5rem;">
                Administrative Console &bull; Academic Year <%= java.time.Year.now().getValue() %>
              </span>
              <h2 style="color: #ffffff; font-size: 1.55rem; margin-bottom: 0.35rem;">
                Grievance Cell Executive Command
              </h2>
              <p style="color: #cbd5e1; font-size: 0.92rem;">
                Logged in as <strong><c:out value="${sessionScope.user.fullName}"/></strong> (<c:out value="${sessionScope.user.email}"/>)
              </p>
            </div>
            <div style="text-align: right;">
              <div style="font-size: 2rem; font-weight: 800; color: #38bdf8;">${stats.resolutionRate}%</div>
              <div style="font-size: 0.78rem; color: #94a3b8; text-transform: uppercase;">Resolution Efficiency Rate</div>
            </div>
          </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="stat-grid">
          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value"><c:out value="${stats.totalGrievances}"/></div>
              <div class="stat-label">Total Grievances</div>
            </div>
            <div class="stat-icon blue">📁</div>
          </div>

          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value" style="color: var(--warning);"><c:out value="${stats.pendingCount}"/></div>
              <div class="stat-label">Pending / Active</div>
            </div>
            <div class="stat-icon yellow">⏳</div>
          </div>

          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value" style="color: #4338ca;"><c:out value="${stats.inProgressCount}"/></div>
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

          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value" style="color: #0f766e;"><c:out value="${stats.totalFeedback}"/></div>
              <div class="stat-label">Facility Reviews</div>
            </div>
            <div class="stat-icon teal">💬</div>
          </div>

          <div class="stat-card">
            <div class="stat-info">
              <div class="stat-value" style="color: #d97706;">${stats.averageRating} ★</div>
              <div class="stat-label">Avg Campus Rating</div>
            </div>
            <div class="stat-icon yellow">⭐</div>
          </div>
        </div>

        <!-- Clean Visualizations Section: Category Breakdown & Satisfaction Distribution -->
        <div style="display: grid; grid-template-columns: 1.2fr 1fr; gap: 2rem; margin-bottom: 2rem;">
          <!-- Category Breakdown Native Chart -->
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Grievances by Category</h3>
              <span style="font-size: 0.8rem; color: var(--text-muted); font-weight: 600;">Distribution</span>
            </div>
            <div class="card-body">
              <c:choose>
                <c:when test="${not empty stats.categoryDistribution}">
                  <div class="chart-container">
                    <c:forEach var="entry" items="${stats.categoryDistribution}">
                      <c:set var="pct" value="${stats.totalGrievances > 0 ? (entry.value * 100 / stats.totalGrievances) : 0}" />
                      <div class="chart-row">
                        <div class="chart-label" title="${entry.key}"><c:out value="${entry.key}"/></div>
                        <div class="chart-bar-bg">
                          <div class="chart-bar-fill" style="width: ${pct > 0 ? pct : 5}%;"></div>
                        </div>
                        <div class="chart-val"><c:out value="${entry.value}"/></div>
                      </div>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>
                  <p style="color: var(--text-muted); text-align: center; padding: 2rem;">No category data available.</p>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <!-- Student Satisfaction Distribution Native Chart -->
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Campus Facility Ratings</h3>
              <span style="font-size: 0.8rem; color: #d97706; font-weight: 700;">★ ${stats.averageRating} / 5.0</span>
            </div>
            <div class="card-body">
              <c:choose>
                <c:when test="${not empty ratingDistribution}">
                  <div class="chart-container">
                    <c:forEach var="star" begin="1" end="5">
                      <c:set var="starKey" value="${6 - star}" />
                      <c:set var="starCount" value="${ratingDistribution[starKey] != null ? ratingDistribution[starKey] : 0}" />
                      <c:set var="starPct" value="${stats.totalFeedback > 0 ? (starCount * 100 / stats.totalFeedback) : 0}" />
                      <div class="chart-row">
                        <div class="chart-label" style="width: 80px; color: #d97706;">
                          ${starKey} Stars
                        </div>
                        <div class="chart-bar-bg">
                          <div class="chart-bar-fill" style="width: ${starPct > 0 ? starPct : 2}%; background: linear-gradient(90deg, #f59e0b 0%, #10b981 100%);"></div>
                        </div>
                        <div class="chart-val">${starCount}</div>
                      </div>
                    </c:forEach>
                  </div>
                  <div style="margin-top: 1.25rem; text-align: center;">
                    <a href="${pageContext.request.contextPath}/admin/manage-feedback" class="btn btn-outline btn-sm">
                      Inspect All Facility Reviews &rarr;
                    </a>
                  </div>
                </c:when>
                <c:otherwise>
                  <p style="color: var(--text-muted); text-align: center; padding: 2rem;">No feedback ratings submitted yet.</p>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <!-- Recent Activity Table -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Recent Grievances Awaiting Action</h3>
            <a href="${pageContext.request.contextPath}/admin/manage-grievances" class="btn btn-outline btn-sm">
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
                        <th>Complainant Student</th>
                        <th>Grievance Subject</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Date Filed</th>
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
                            <div style="font-weight: 600;"><c:out value="${item.studentName}"/></div>
                            <div style="font-size: 0.78rem; color: var(--text-muted);"><c:out value="${item.studentRollNo}"/></div>
                          </td>
                          <td>
                            <div style="font-weight: 600; color: var(--primary);"><c:out value="${item.title}"/></div>
                            <div style="font-size: 0.78rem; color: var(--text-muted);"><c:out value="${item.department}"/></div>
                          </td>
                          <td><span class="badge badge-muted"><c:out value="${item.category}"/></span></td>
                          <td><span class="badge ${item.priorityBadgeClass}"><c:out value="${item.priority}"/></span></td>
                          <td><span class="badge ${item.statusBadgeClass}"><c:out value="${item.status}"/></span></td>
                          <td style="font-size: 0.85rem; color: var(--text-muted);">
                            <fmt:formatDate value="${item.createdAt}" pattern="dd MMM, hh:mm a" />
                          </td>
                          <td>
                            <div style="display: flex; gap: 6px;">
                              <a href="${pageContext.request.contextPath}/admin/grievance-details?id=${item.id}"
                                 class="btn btn-outline btn-sm">
                                View
                              </a>
                              <button type="button" class="btn btn-primary btn-sm"
                                      onclick="openUpdateModal('${item.id}', '${item.trackingId}', '${item.status}', '${item.adminResponse != null ? item.adminResponse.replace('\'', '\\\'') : ''}', '${item.department}')">
                                Resolve
                              </button>
                            </div>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:when>
              <c:otherwise>
                <div class="empty-state">
                  <div class="empty-icon">✅</div>
                  <h4 class="empty-title">All Grievances Addressed</h4>
                  <p class="empty-desc">There are no pending grievances in the system queue.</p>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

      </main>

      <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
  </div>

  <!-- Status Update Modal -->
  <div class="modal-overlay" id="updateGrievanceModal">
    <div class="modal-card">
      <form action="${pageContext.request.contextPath}/admin/update-grievance" method="POST">
        <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
        <input type="hidden" id="modalGrievanceId" name="grievanceId" value="">

        <div class="modal-header">
          <h3>Update Grievance: <span id="modalTrackingIdDisplay" style="color: var(--accent); font-family: monospace;"></span></h3>
          <button type="button" class="modal-close" onclick="closeModal('updateGrievanceModal')">&times;</button>
        </div>

        <div class="modal-body">
          <div class="form-group">
            <label for="modalStatusSelect" class="form-label">Resolution Status <span class="required">*</span></label>
            <select id="modalStatusSelect" name="status" class="form-control" required>
              <option value="Submitted">Submitted (Under initial receipt)</option>
              <option value="Under Review">Under Review (Assessing validity)</option>
              <option value="In Progress">In Progress (Remedial action underway)</option>
              <option value="Resolved">Resolved (Matter fully resolved)</option>
              <option value="Rejected">Rejected (Inadmissible / invalid request)</option>
            </select>
          </div>

          <div class="form-group">
            <label for="modalAssignedDepartment" class="form-label">Assigned Department</label>
            <input type="text" id="modalAssignedDepartment" name="assignedDepartment" class="form-control"
                   placeholder="e.g. Computer Science & Engineering">
          </div>

          <div class="form-group">
            <label for="modalAdminResponse" class="form-label">Official Response (Visible to Student) <span class="required">*</span></label>
            <textarea id="modalAdminResponse" name="adminResponse" class="form-control" rows="4"
                      placeholder="Detail the investigation outcomes and action taken for the student..." required></textarea>
          </div>

          <div class="form-group">
            <label for="modalRemarks" class="form-label">Audit Remarks for Timeline Log</label>
            <input type="text" id="modalRemarks" name="remarks" class="form-control"
                   placeholder="e.g. Workstation RAM modules replaced; issue resolved.">
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-outline" onclick="closeModal('updateGrievanceModal')">Cancel</button>
          <button type="submit" class="btn btn-primary">Save &amp; Update Status</button>
        </div>
      </form>
    </div>
  </div>

</body>
</html>
