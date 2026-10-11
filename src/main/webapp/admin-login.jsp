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
  <title>Administrator Login | Digital Grievance Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

  <!-- Navigation Bar -->
  <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

  <main class="auth-wrapper">
    <div class="auth-card">
      <div class="auth-header" style="background: linear-gradient(135deg, #1e1b4b 0%, #0f172a 100%);">
        <div class="brand-icon" style="background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);">🛡️</div>
        <h2>Administrative Redressal Cell</h2>
        <p>Restricted access for Grievance Committee &amp; Faculty Officers</p>
      </div>

      <div class="auth-body">
        <div class="admin-banner">
          🔒 <strong>Official Notice:</strong> All administrative activities, status changes, and responses are cryptographically authenticated and audit-logged.
        </div>

        <!-- Action Messages -->
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <form action="${pageContext.request.contextPath}/auth/admin-login" method="POST">
          <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

          <div class="form-group">
            <label for="email" class="form-label">Administrator Email <span class="required">*</span></label>
            <input type="email" id="email" name="email" class="form-control"
                   placeholder="e.g. admin@college.edu" required autofocus
                   value="${param.email != null ? param.email : ''}">
          </div>

          <div class="form-group">
            <label for="password" class="form-label">Administrative Password <span class="required">*</span></label>
            <input type="password" id="password" name="password" class="form-control"
                   placeholder="Enter your administrative credentials" required>
          </div>

          <button type="submit" class="btn btn-navy btn-block" style="background-color: #312e81;">
            <span>Authenticate as Administrator</span> &rarr;
          </button>
        </form>

        <div style="margin-top: 1.5rem; padding: 0.95rem; background-color: var(--bg-subtle); border-radius: var(--radius-sm); border: 1px dashed #cbd5e1; font-size: 0.82rem;">
          <strong style="color: var(--primary);">💡 Demo Admin Credentials for Viva:</strong><br>
          Email: <code style="color: #4338ca;">admin@college.edu</code><br>
          Password: <code style="color: #4338ca;">AdminPassword@123</code>
        </div>
      </div>

      <div class="auth-footer">
        Are you a student looking to submit a grievance?
        <br>
        <a href="${pageContext.request.contextPath}/login.jsp">&larr; Return to Student Portal Login</a>
      </div>
    </div>
  </main>

  <!-- Footer -->
  <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>
