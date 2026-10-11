<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="public-nav">
  <div class="nav-container">
    <a href="${pageContext.request.contextPath}/index.jsp" class="brand-logo">
      <div class="brand-icon">🎓</div>
      <div class="brand-text">
        <h1>College Grievance &amp; Feedback Portal</h1>
        <p>Institutional Redressal System</p>
      </div>
    </a>
    <nav>
      <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/index.jsp#features">Features</a></li>
        <li><a href="${pageContext.request.contextPath}/index.jsp#guidelines">Guidelines</a></li>
        <c:choose>
          <c:when test="${not empty sessionScope.user}">
            <c:choose>
              <c:when test="${sessionScope.user.role == 'ADMIN'}">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary btn-sm">Admin Dashboard</a></li>
              </c:when>
              <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary btn-sm">Student Portal</a></li>
              </c:otherwise>
            </c:choose>
            <li><a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-white btn-sm">Logout</a></li>
          </c:when>
          <c:otherwise>
            <li><a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-white btn-sm">Student Login</a></li>
            <li><a href="${pageContext.request.contextPath}/admin-login.jsp" class="btn btn-outline-white btn-sm">Admin Login</a></li>
            <li><a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary btn-sm">Register</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </nav>
  </div>
</header>
