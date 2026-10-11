<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  String csrfToken = com.college.portal.util.CSRFUtil.getToken(session);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Account Profile | Digital Grievance Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="profile" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">User Account Profile</h2>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; align-items: start;">
          <!-- Profile Details & Edit Form -->
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Personal &amp; Department Details</h3>
            </div>

            <div class="card-body">
              <form action="${pageContext.request.contextPath}/profile/update" method="POST">
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

                <div class="form-group">
                  <label class="form-label">Registered Email</label>
                  <input type="email" class="form-control" value="<c:out value="${sessionScope.user.email}"/>" disabled style="background-color: var(--bg-subtle);">
                  <div class="form-text">Official college email cannot be changed.</div>
                </div>

                <c:if test="${sessionScope.user.student}">
                  <div class="form-group">
                    <label class="form-label">Student Roll Number / ID</label>
                    <input type="text" class="form-control" value="<c:out value="${sessionScope.user.studentId}"/>" disabled style="background-color: var(--bg-subtle);">
                  </div>
                </c:if>

                <div class="form-group">
                  <label for="fullName" class="form-label">Full Name <span class="required">*</span></label>
                  <input type="text" id="fullName" name="fullName" class="form-control"
                         value="<c:out value="${sessionScope.user.fullName}"/>" required>
                </div>

                <div class="form-group">
                  <label for="department" class="form-label">Department / Office</label>
                  <input type="text" id="department" name="department" class="form-control"
                         value="<c:out value="${sessionScope.user.department}"/>">
                </div>

                <div class="form-group">
                  <label for="phone" class="form-label">Contact Phone</label>
                  <input type="tel" id="phone" name="phone" class="form-control"
                         value="<c:out value="${sessionScope.user.phone}"/>">
                </div>

                <button type="submit" class="btn btn-primary">
                  Save Profile Updates
                </button>
              </form>
            </div>
          </div>

          <!-- Password Change Form -->
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Security &amp; Password Update</h3>
            </div>

            <div class="card-body">
              <form action="${pageContext.request.contextPath}/profile/change-password" method="POST">
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

                <div class="form-group">
                  <label for="currentPassword" class="form-label">Current Password <span class="required">*</span></label>
                  <input type="password" id="currentPassword" name="currentPassword" class="form-control"
                         placeholder="Enter current password" required>
                </div>

                <div class="form-group">
                  <label for="newPassword" class="form-label">New Password <span class="required">*</span></label>
                  <input type="password" id="newPassword" name="newPassword" class="form-control"
                         placeholder="Minimum 6 characters" required>
                </div>

                <div class="form-group">
                  <label for="confirmPassword" class="form-label">Confirm New Password <span class="required">*</span></label>
                  <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                         placeholder="Re-enter new password" required>
                </div>

                <button type="submit" class="btn btn-navy">
                  Update Password
                </button>
              </form>
            </div>
          </div>
        </div>
      </main>

      <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
  </div>

</body>
</html>
