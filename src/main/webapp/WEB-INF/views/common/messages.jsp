<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty param.success or not empty requestScope.success}">
  <div class="alert alert-success alert-dismissible">
    <span>✅</span>
    <div><c:out value="${not empty param.success ? param.success : requestScope.success}"/></div>
  </div>
</c:if>

<c:if test="${not empty param.error or not empty requestScope.error}">
  <div class="alert alert-danger alert-dismissible">
    <span>⚠️</span>
    <div><c:out value="${not empty param.error ? param.error : requestScope.error}"/></div>
  </div>
</c:if>

<c:if test="${not empty param.info or not empty requestScope.info}">
  <div class="alert alert-info alert-dismissible">
    <span>ℹ️</span>
    <div><c:out value="${not empty param.info ? param.info : requestScope.info}"/></div>
  </div>
</c:if>
