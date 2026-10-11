<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>403 - Access Prohibited | Digital Grievance Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #f8fafc; text-align: center; padding: 2rem;">

  <div class="card" style="max-width: 540px; padding: 3rem 2rem; border-top: 5px solid var(--danger);">
    <div style="font-size: 4rem; margin-bottom: 1rem;">⛔</div>
    <h1 style="font-size: 2.25rem; color: var(--primary); margin-bottom: 0.5rem;">403 Forbidden</h1>
    <h3 style="font-size: 1.15rem; color: var(--danger); margin-bottom: 1rem;">Unauthorized Resource Access</h3>
    <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 2rem; line-height: 1.6;">
      You do not possess the required security permissions to inspect this resource. Cross-student grievance inspections and unauthenticated administrative actions are strictly prevented.
    </p>

    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
      <c:choose>
        <c:when test="${sessionScope.user.role == 'ADMIN'}">
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-navy">Return to Admin Dashboard</a>
        </c:when>
        <c:when test="${sessionScope.user.role == 'STUDENT'}">
          <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary">Return to Student Dashboard</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Return to Portal Home</a>
        </c:otherwise>
      </c:choose>
      <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline">Log Out</a>
    </div>
  </div>

</body>
</html>
