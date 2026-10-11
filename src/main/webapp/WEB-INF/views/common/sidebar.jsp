<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="sidebar" id="sidebar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="sidebar-brand">
    <div class="brand-icon">🎓</div>
    <div class="sidebar-brand-text">
      <h2>Grievance Portal</h2>
      <span><c:out value="${sessionScope.user.role}"/> PORTAL</span>
    </div>
  </a>

  <ul class="sidebar-menu">
    <c:choose>
      <c:when test="${sessionScope.user.role == 'ADMIN'}">
        <li class="menu-category">Institutional Admin</li>
        <li>
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${param.activeNav == 'dashboard' ? 'active' : ''}">
            <span class="sidebar-icon">📊</span>
            <span>Dashboard &amp; Stats</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/admin/manage-grievances" class="sidebar-link ${param.activeNav == 'grievances' ? 'active' : ''}">
            <span class="sidebar-icon">📑</span>
            <span>Manage Grievances</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/admin/manage-feedback" class="sidebar-link ${param.activeNav == 'feedback' ? 'active' : ''}">
            <span class="sidebar-icon">⭐</span>
            <span>Manage Feedback</span>
          </a>
        </li>
      </c:when>

      <c:otherwise>
        <li class="menu-category">Student Services</li>
        <li>
          <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-link ${param.activeNav == 'dashboard' ? 'active' : ''}">
            <span class="sidebar-icon">📊</span>
            <span>My Dashboard</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/student/submit-grievance" class="sidebar-link ${param.activeNav == 'submit_grievance' ? 'active' : ''}">
            <span class="sidebar-icon">✍️</span>
            <span>Submit Grievance</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/student/my-grievances" class="sidebar-link ${param.activeNav == 'my_grievances' ? 'active' : ''}">
            <span class="sidebar-icon">📂</span>
            <span>My Grievances</span>
          </a>
        </li>

        <li class="menu-category">Campus Feedback</li>
        <li>
          <a href="${pageContext.request.contextPath}/student/submit-feedback" class="sidebar-link ${param.activeNav == 'submit_feedback' ? 'active' : ''}">
            <span class="sidebar-icon">⭐</span>
            <span>Give Feedback</span>
          </a>
        </li>
        <li>
          <a href="${pageContext.request.contextPath}/student/my-feedback" class="sidebar-link ${param.activeNav == 'my_feedback' ? 'active' : ''}">
            <span class="sidebar-icon">💬</span>
            <span>My Feedback History</span>
          </a>
        </li>
      </c:otherwise>
    </c:choose>

    <li class="menu-category">Account Settings</li>
    <li>
      <a href="${pageContext.request.contextPath}/profile" class="sidebar-link ${param.activeNav == 'profile' ? 'active' : ''}">
        <span class="sidebar-icon">👤</span>
        <span>My Profile</span>
      </a>
    </li>
    <li>
      <a href="${pageContext.request.contextPath}/auth/logout" class="sidebar-link">
        <span class="sidebar-icon">🚪</span>
        <span>Log Out</span>
      </a>
    </li>
  </ul>

  <div class="sidebar-footer">
    <div class="user-profile-badge">
      <div class="user-avatar">
        ${not empty sessionScope.user.fullName ? sessionScope.user.fullName.substring(0, 1).toUpperCase() : 'U'}
      </div>
      <div class="user-info">
        <div class="user-name"><c:out value="${sessionScope.user.fullName}"/></div>
        <div class="user-role">
          <c:choose>
            <c:when test="${sessionScope.user.role == 'ADMIN'}">Administrator</c:when>
            <c:otherwise><c:out value="${sessionScope.user.studentId}"/></c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</aside>
