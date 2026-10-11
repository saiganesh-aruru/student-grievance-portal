<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Feedback Submissions | Student Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="my_feedback" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">My Feedback History</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/student/submit-feedback" class="btn btn-teal btn-sm">
            <span>+ Submit Feedback</span>
          </a>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Past Campus Feedback &amp; Ratings (${feedbackList != null ? feedbackList.size() : 0})</h3>
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

                      <div style="font-size: 0.78rem; color: var(--text-muted); border-top: 1px solid var(--border-color); padding-top: 0.5rem;">
                        Submitted on: <fmt:formatDate value="${fb.createdAt}" pattern="dd MMMM yyyy, hh:mm a" />
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:when>

              <c:otherwise>
                <div class="empty-state">
                  <div class="empty-icon">⭐</div>
                  <h4 class="empty-title">No Feedback Submitted</h4>
                  <p class="empty-desc">
                    You have not rated any campus facilities or services yet. Your feedback helps enhance campus amenities.
                  </p>
                  <a href="${pageContext.request.contextPath}/student/submit-feedback" class="btn btn-teal">
                    + Share Your Experience
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
