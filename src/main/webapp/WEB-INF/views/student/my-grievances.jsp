<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Submitted Grievances | Student Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="my_grievances" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">My Grievances</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/student/submit-grievance" class="btn btn-primary btn-sm">
            <span>+ New Grievance</span>
          </a>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <!-- Filters Bar -->
        <form action="${pageContext.request.contextPath}/student/my-grievances" method="GET" class="filter-bar">
          <div class="filter-group">
            <label for="statusFilter">Status:</label>
            <select name="status" id="statusFilter" class="form-control" style="width: auto; padding: 0.4rem 0.75rem;" onchange="this.form.submit()">
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
            <select name="category" id="catFilter" class="form-control" style="width: auto; padding: 0.4rem 0.75rem;" onchange="this.form.submit()">
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

          <c:if test="${not empty selectedStatus or not empty selectedCategory}">
            <a href="${pageContext.request.contextPath}/student/my-grievances" class="btn btn-outline btn-sm" style="margin-left: auto;">
              Clear Filters
            </a>
          </c:if>
        </form>

        <!-- Grievances Table Card -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Submitted Grievance Records (${grievances != null ? grievances.size() : 0})</h3>
          </div>

          <div class="card-body" style="padding: 0;">
            <c:choose>
              <c:when test="${not empty grievances}">
                <div class="table-responsive">
                  <table class="data-table">
                    <thead>
                      <tr>
                        <th>Tracking ID</th>
                        <th>Subject &amp; Department</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Submitted On</th>
                        <th>Action</th>
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
                            <div style="font-weight: 600; color: var(--primary);"><c:out value="${g.title}"/></div>
                            <div style="font-size: 0.8rem; color: var(--text-muted);"><c:out value="${g.department}"/></div>
                          </td>
                          <td><span class="badge badge-muted"><c:out value="${g.category}"/></span></td>
                          <td><span class="badge ${g.priorityBadgeClass}"><c:out value="${g.priority}"/></span></td>
                          <td><span class="badge ${g.statusBadgeClass}"><c:out value="${g.status}"/></span></td>
                          <td style="font-size: 0.85rem; color: var(--text-muted);">
                            <fmt:formatDate value="${g.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
                          </td>
                          <td>
                            <a href="${pageContext.request.contextPath}/student/grievance-details?id=${g.id}" class="btn btn-primary btn-sm">
                              Track Details &rarr;
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
                  <div class="empty-icon">📁</div>
                  <h4 class="empty-title">No Grievances Found</h4>
                  <p class="empty-desc">
                    No grievance records match your selected filter criteria.
                  </p>
                  <a href="${pageContext.request.contextPath}/student/submit-grievance" class="btn btn-primary">
                    + Lodge a Grievance
                  </a>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </main>

      <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
  </div>

</body>
</html>
