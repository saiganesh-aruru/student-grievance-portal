<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>500 - Server Error | Digital Grievance Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #f8fafc; text-align: center; padding: 2rem;">

  <div class="card" style="max-width: 650px; padding: 2.5rem 2rem; border-top: 5px solid var(--warning); text-align: left;">
    <div style="text-align: center; font-size: 3.5rem; margin-bottom: 0.5rem;">⚠️</div>
    <h1 style="font-size: 2rem; color: var(--primary); text-align: center; margin-bottom: 0.25rem;">Internal Application Exception</h1>
    <h3 style="font-size: 1.05rem; color: var(--warning); text-align: center; margin-bottom: 1.5rem;">An unexpected server-side event occurred</h3>

    <div style="background-color: var(--bg-main); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 1.25rem; font-size: 0.88rem; margin-bottom: 1.5rem;">
      <strong style="color: var(--primary);">Troubleshooting Guide for Lab Demonstrations:</strong>
      <ol style="padding-left: 1.25rem; margin-top: 0.5rem; color: var(--text-muted); line-height: 1.6;">
        <li>Ensure your local <strong>MySQL service</strong> is running on port <code>3306</code>.</li>
        <li>Confirm that database <code>student_grievance_portal</code> has been initialized using <code>sql/schema.sql</code> and <code>sql/sample_data.sql</code>.</li>
        <li>Verify credentials configured inside <code>src/main/resources/db.properties</code>.</li>
      </ol>
    </div>

    <c:if test="${not empty pageContext.exception}">
      <div style="background-color: #fee2e2; color: #991b1b; padding: 0.85rem; border-radius: var(--radius-sm); font-size: 0.82rem; font-family: monospace; margin-bottom: 1.5rem; overflow-x: auto;">
        Exception: <c:out value="${pageContext.exception.message}"/>
      </div>
    </c:if>

    <div style="text-align: center;">
      <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Return to Portal Home</a>
    </div>
  </div>

</body>
</html>
