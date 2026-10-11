<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>404 - Page Not Found | Digital Grievance Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #f8fafc; text-align: center; padding: 2rem;">

  <div class="card" style="max-width: 520px; padding: 3rem 2rem; border-top: 5px solid var(--accent);">
    <div style="font-size: 4rem; margin-bottom: 1rem;">🔍</div>
    <h1 style="font-size: 2.25rem; color: var(--primary); margin-bottom: 0.5rem;">404 Not Found</h1>
    <h3 style="font-size: 1.15rem; color: var(--text-muted); margin-bottom: 1rem;">The requested portal page does not exist</h3>
    <p style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 2rem; line-height: 1.6;">
      The URL or tracking ticket you entered could not be located in the college portal system. Please verify the link or return to your dashboard.
    </p>

    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
      <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Return to Portal Home</a>
    </div>
  </div>

</body>
</html>
