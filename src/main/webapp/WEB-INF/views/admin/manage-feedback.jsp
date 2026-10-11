<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Facility Feedback | Institutional Redressal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="feedback" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">Manage Campus Feedback</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline btn-sm">
            <span>&larr; Admin Overview</span>
          </a>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <!-- Filters Bar -->
        <form action="${pageContext.request.contextPath}/admin/manage-feedback" method="GET" class="filter-bar">
          <div class="filter-group">
            <label for="catFilter">Category:</label>
            <select name="category" id="catFilter" class="form-control" style="width: auto;" onchange="this.form.submit()">
              <option value="ALL" ${selectedCategory == 'ALL' or empty selectedCategory ? 'selected' : ''}>All Categories</option>
              <option value="Campus Wi-Fi/IT" ${selectedCategory == 'Campus Wi-Fi/IT' ? 'selected' : ''}>Campus Wi-Fi/IT</option>
              <option value="Hostel" ${selectedCategory == 'Hostel' ? 'selected' : ''}>Hostel</option>
              <option value="Mess/Canteen" ${selectedCategory == 'Mess/Canteen' ? 'selected' : ''}>Mess/Canteen</option>
              <option value="Library" ${selectedCategory == 'Library' ? 'selected' : ''}>Library</option>
              <option value="Laboratory" ${selectedCategory == 'Laboratory' ? 'selected' : ''}>Laboratory</option>
              <option value="Sports &amp; Gym" ${selectedCategory == 'Sports & Gym' ? 'selected' : ''}>Sports &amp; Gym</option>
              <option value="Transport" ${selectedCategory == 'Transport' ? 'selected' : ''}>Transport</option>
              <option value="Administration" ${selectedCategory == 'Administration' ? 'selected' : ''}>Administration</option>
              <option value="Other" ${selectedCategory == 'Other' ? 'selected' : ''}>Other</option>
            </select>
          </div>

          <div class="filter-group">
            <label for="ratingFilter">Rating:</label>
            <select name="rating" id="ratingFilter" class="form-control" style="width: auto;" onchange="this.form.submit()">
              <option value="" ${empty selectedRating ? 'selected' : ''}>All Ratings</option>
              <option value="5" ${selectedRating == 5 ? 'selected' : ''}>5 Stars (Outstanding)</option>
              <option value="4" ${selectedRating == 4 ? 'selected' : ''}>4 Stars (Good)</option>
              <option value="3" ${selectedRating == 3 ? 'selected' : ''}>3 Stars (Average)</option>
              <option value="2" ${selectedRating == 2 ? 'selected' : ''}>2 Stars (Fair)</option>
              <option value="1" ${selectedRating == 1 ? 'selected' : ''}>1 Star (Poor)</option>
            </select>
          </div>

          <c:if test="${not empty selectedCategory or not empty selectedRating}">
            <a href="${pageContext.request.contextPath}/admin/manage-feedback" class="btn btn-outline btn-sm" style="margin-left: auto;">
              Clear Filters
            </a>
          </c:if>
        </form>

        <!-- Feedback Records Table -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Campus Facility Evaluations (${feedbackList != null ? feedbackList.size() : 0})</h3>
          </div>

          <div class="card-body">
            <c:choose>
              <c:when test="${not empty feedbackList}">
                <div style="display: flex; flex-direction: column; gap: 1.25rem;">
                  <c:forEach var="fb" items="${feedbackList}">
                    <div style="background-color: var(--bg-main); border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 1.25rem 1.5rem;">
                      <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 0.5rem;">
                        <div>
                          <span class="badge badge-info" style="margin-right: 8px;"><c:out value="${fb.category}"/></span>
                          <strong style="color: var(--primary); font-size: 1.05rem;"><c:out value="${fb.subject}"/></strong>
                        </div>
                        <div style="color: #f59e0b; font-size: 1.25rem; font-weight: 700; letter-spacing: 2px;">
                          ${fb.starsDisplay}
                          <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: normal;">(${fb.rating}/5)</span>
                        </div>
                      </div>

                      <p style="color: var(--text-main); font-size: 0.92rem; line-height: 1.6; margin-bottom: 0.75rem;">
                        <c:out value="${fb.comments}"/>
                      </p>

                      <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.78rem; color: var(--text-muted); border-top: 1px solid var(--border-color); padding-top: 0.5rem;">
                        <div>
                          Submitted by: <strong><c:out value="${fb.studentName}"/></strong>
                          (<c:out value="${fb.studentRollNo}"/> &bull; <c:out value="${fb.studentDepartment}"/>)
                        </div>
                        <div>
                          <fmt:formatDate value="${fb.createdAt}" pattern="dd MMM yyyy, hh:mm a" />
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:when>

              <c:otherwise>
                <div class="empty-state">
                  <div class="empty-icon">⭐</div>
                  <h4 class="empty-title">No Reviews Found</h4>
                  <p class="empty-desc">No student facility feedback matches your selected filters.</p>
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
