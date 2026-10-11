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
  <title>Student Registration | Digital Grievance Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

  <!-- Navigation Bar -->
  <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

  <main class="auth-wrapper">
    <div class="auth-card wide">
      <div class="auth-header">
        <div class="brand-icon">📝</div>
        <h2>Student Account Registration</h2>
        <p>Register your official student credentials to access portal services</p>
      </div>

      <div class="auth-body">
        <!-- Action Messages -->
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <div id="formClientError" class="alert alert-danger" style="display: none;"></div>

        <form action="${pageContext.request.contextPath}/auth/register" method="POST" onsubmit="return validateRegistrationForm()">
          <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

          <div class="form-row">
            <div class="form-group">
              <label for="fullName" class="form-label">Full Name <span class="required">*</span></label>
              <input type="text" id="fullName" name="fullName" class="form-control"
                     placeholder="e.g. Rahul Sharma" required
                     value="${param.fullName != null ? param.fullName : ''}">
            </div>

            <div class="form-group">
              <label for="studentId" class="form-label">Student ID / Roll No. <span class="required">*</span></label>
              <input type="text" id="studentId" name="studentId" class="form-control"
                     placeholder="e.g. CS-2023-108" required
                     value="${param.studentId != null ? param.studentId : ''}">
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="email" class="form-label">College Email Address <span class="required">*</span></label>
              <input type="email" id="email" name="email" class="form-control"
                     placeholder="e.g. rahul.sharma@college.edu" required
                     value="${param.email != null ? param.email : ''}">
              <div class="form-text">Must be a valid email domain.</div>
            </div>

            <div class="form-group">
              <label for="department" class="form-label">Department / Branch <span class="required">*</span></label>
              <select id="department" name="department" class="form-control" required>
                <option value="">-- Select Your Department --</option>
                <option value="Computer Science &amp; Engineering">Computer Science &amp; Engineering</option>
                <option value="Electronics &amp; Communication">Electronics &amp; Communication</option>
                <option value="Electrical &amp; Electronics">Electrical &amp; Electronics</option>
                <option value="Mechanical Engineering">Mechanical Engineering</option>
                <option value="Civil Engineering">Civil Engineering</option>
                <option value="Information Technology">Information Technology</option>
                <option value="Management Studies">Management Studies</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="phone" class="form-label">Contact Phone Number</label>
            <input type="tel" id="phone" name="phone" class="form-control"
                   placeholder="e.g. +91 9876543210"
                   value="${param.phone != null ? param.phone : ''}">
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="password" class="form-label">Create Password <span class="required">*</span></label>
              <input type="password" id="password" name="password" class="form-control"
                     placeholder="Minimum 6 characters" required>
            </div>

            <div class="form-group">
              <label for="confirmPassword" class="form-label">Confirm Password <span class="required">*</span></label>
              <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                     placeholder="Re-enter password" required>
            </div>
          </div>

          <button type="submit" class="btn btn-primary btn-block" style="margin-top: 0.5rem;">
            <span>Create Student Account</span> &rarr;
          </button>
        </form>
      </div>

      <div class="auth-footer">
        Already registered?
        <a href="${pageContext.request.contextPath}/login.jsp">Log in to your account</a>
      </div>
    </div>
  </main>

  <!-- Footer -->
  <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>
