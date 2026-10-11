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
  <title>Manage All Grievances | Administrative Cell</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="grievances" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">Manage Grievances</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline btn-sm">
            <span>&larr; Admin Overview</span>
          </a>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <!-- Search and Filter Bar -->
        <form action="${pageContext.request.contextPath}/admin/manage-grievances" method="GET" class="filter-bar">
          <div class="filter-group" style="flex: 1; min-width: 200px;">
            <input type="text" name="keyword" class="form-control" placeholder="Search by student, ID, or title..."
                   value="${keyword != null ? keyword : ''}">
          </div>

          <div class="filter-group">
            <label for="statusFilter">Status:</label>
            <select name="status" id="statusFilter" class="form-control" style="width: auto;">
              <option value="ALL" ${selectedStatus == 'ALL' or empty selectedStatus ? 'selected' : ''}>All Statuses</option>
              <option value="Submitted" ${selectedStatus == 'Submitted' ? 'selected' : ''}>Submitted</option>
              <option value="Under Review" ${selectedStatus == 'Under Review' ? 'selected' : ''}>Under Review</option>
              <option value="In Progress" ${selectedStatus == 'In Progress' ? 'selected' : ''}>In Progress</option>
              <option value="Resolved" ${selectedStatus == 'Resolved' ? 'selected' : ''}>Resolved</option>
              <option value="Rejected" ${selectedStatus == 'Rejected' ? 'selected' : ''}>Rejected</option>
            </select>
          </div>

          <div class="filter-group">
            <label for="catFilter">Category:</label>
            <select name="category" id="catFilter" class="form-control" style="width: auto;">
              <option value="ALL" ${selectedCategory == 'ALL' or empty selectedCategory ? 'selected' : ''}>All Categories</option>
              <option value="Academics" ${selectedCategory == 'Academics' ? 'selected' : ''}>Academics</option>
              <option value="Examinations" ${selectedCategory == 'Examinations' ? 'selected' : ''}>Examinations</option>
              <option value="Faculty" ${selectedCategory == 'Faculty' ? 'selected' : ''}>Faculty</option>
              <option value="Infrastructure" ${selectedCategory == 'Infrastructure' ? 'selected' : ''}>Infrastructure</option>
              <option value="Hostel" ${selectedCategory == 'Hostel' ? 'selected' : ''}>Hostel</option>
              <option value="Transport" ${selectedCategory == 'Transport' ? 'selected' : ''}>Transport</option>
              <option value="Library" ${selectedCategory == 'Library' ? 'selected' : ''}>Library</option>
              <option value="Other" ${selectedCategory == 'Other' ? 'selected' : ''}>Other</option>
            </select>
          </div>

          <div class="filter-group">
            <label for="priFilter">Priority:</label>
            <select name="priority" id="priFilter" class="form-control" style="width: auto;">
              <option value="ALL" ${selectedPriority == 'ALL' or empty selectedPriority ? 'selected' : ''}>All Priorities</option>
              <option value="Low" ${selectedPriority == 'Low' ? 'selected' : ''}>Low</option>
              <option value="Medium" ${selectedPriority == 'Medium' ? 'selected' : ''}>Medium</option>
              <option value="High" ${selectedPriority == 'High' ? 'selected' : ''}>High</option>
              <option value="Urgent" ${selectedPriority == 'Urgent' ? 'selected' : ''}>Urgent</option>
            </select>
          </div>

          <button type="submit" class="btn btn-navy btn-sm">Filter</button>
          <a href="${pageContext.request.contextPath}/admin/manage-grievances" class="btn btn-outline btn-sm">Reset</a>
        </form>

        <!-- Grievances Table Card -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Institutional Grievance Queue (${grievances != null ? grievances.size() : 0})</h3>
          </div>

          <div class="card-body" style="padding: 0;">
            <c:choose>
              <c:when test="${not empty grievances}">
                <div class="table-responsive">
                  <table class="data-table">
                    <thead>
                      <tr>
                        <th>Tracking ID</th>
                        <th>Complainant Student</th>
                        <th>Subject &amp; Dept</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Submission Date</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="g" items="${grievances}">
                        <tr>
                          <td>
                            <strong style="color: var(--accent); font-family: monospace; font-size: 0.95rem;">
                              <c:out value="${g.trackingId}"/>
                            </strong>
                          </td>
                          <td>
                            <div style="font-weight: 600; color: var(--primary);"><c:out value="${g.studentName}"/></div>
                            <div style="font-size: 0.78rem; color: var(--text-muted);"><c:out value="${g.studentRollNo}"/></div>
                          </td>
                          <td>
                            <div style="font-weight: 600;"><c:out value="${g.title}"/></div>
                            <div style="font-size: 0.78rem; color: var(--text-muted);"><c:out value="${g.department}"/></div>
                          </td>
                          <td><span class="badge badge-muted"><c:out value="${g.category}"/></span></td>
                          <td><span class="badge ${g.priorityBadgeClass}"><c:out value="${g.priority}"/></span></td>
                          <td><span class="badge ${g.statusBadgeClass}"><c:out value="${g.status}"/></span></td>
                          <td style="font-size: 0.85rem; color: var(--text-muted);">
                            <fmt:formatDate value="${g.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
                          </td>
                          <td>
                            <div style="display: flex; gap: 6px;">
                              <a href="${pageContext.request.contextPath}/admin/grievance-details?id=${g.id}" class="btn btn-outline btn-sm">
                                View
                              </a>
                              <button type="button" class="btn btn-primary btn-sm"
                                      onclick="openUpdateModal('${g.id}', '${g.trackingId}', '${g.status}', '${g.adminResponse != null ? g.adminResponse.replace('\'', '\\\'') : ''}', '${g.department}')">
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
                  <div class="empty-icon">📂</div>
                  <h4 class="empty-title">No Grievances Found</h4>
                  <p class="empty-desc">No records match your selected search and filter parameters.</p>
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
                   placeholder="e.g. Action completed by faculty committee.">
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
