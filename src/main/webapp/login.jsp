<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  // Ensure session and CSRF token exist
  String csrfToken = com.college.portal.util.CSRFUtil.getToken(session);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Student Login | Digital Grievance Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

  <!-- Navigation Bar -->
  <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

  <main class="auth-wrapper">
    <div class="auth-card">
      <div class="auth-header">
        <div class="brand-icon">🎓</div>
        <h2>Student Portal Sign-In</h2>
        <p>Access your grievances, file complaints, and review feedback</p>
      </div>

      <div class="auth-body">
        <!-- System and Action Messages -->
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <div id="formClientError" class="alert alert-danger" style="display: none;"></div>

        <form action="${pageContext.request.contextPath}/auth/login" method="POST">
          <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

          <div class="form-group">
            <label for="email" class="form-label">College Email Address <span class="required">*</span></label>
            <input type="email" id="email" name="email" class="form-control"
                   placeholder="e.g. alex.student@college.edu" required autofocus
                   value="${param.email != null ? param.email : ''}">
          </div>

          <div class="form-group">
            <label for="password" class="form-label">Password <span class="required">*</span></label>
            <input type="password" id="password" name="password" class="form-control"
                   placeholder="Enter your account password" required>
          </div>

          <button type="submit" class="btn btn-primary btn-block">
            <span>Sign In to Student Dashboard</span> &rarr;
          </button>
        </form>

        <div style="margin-top: 1.5rem; padding: 0.95rem; background-color: var(--bg-subtle); border-radius: var(--radius-sm); border: 1px dashed #cbd5e1; font-size: 0.82rem;">
          <strong style="color: var(--primary);">💡 Demo Student Credentials for Viva:</strong><br>
          Email: <code style="color: #0284c7;">alex.student@college.edu</code><br>
          Password: <code style="color: #0284c7;">StudentPassword@123</code>
        </div>
      </div>

      <div class="auth-footer">
        Don't have an account yet?
        <a href="${pageContext.request.contextPath}/register.jsp">Register as a Student</a>
        <div style="margin-top: 0.5rem;">
          <a href="${pageContext.request.contextPath}/admin-login.jsp" style="color: var(--text-muted); font-size: 0.82rem;">Staff / Administrator Login &rarr;</a>
        </div>
      </div>
    </div>
  </main>

  <!-- Footer -->
  <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>
