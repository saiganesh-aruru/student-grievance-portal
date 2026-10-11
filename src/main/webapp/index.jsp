<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Digital Student Grievance &amp; Feedback Portal | College Official</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>

  <!-- Navigation Bar -->
  <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

  <!-- Hero Section -->
  <section class="hero-section">
    <div class="hero-container">
      <div class="hero-content">
        <div class="hero-badge">
          <span>🏛️</span> Official Campus Redressal Portal
        </div>
        <h1 class="hero-title">
          Empowering Student Voices, <span>Ensuring Prompt Redressal</span>.
        </h1>
        <p class="hero-subtitle">
          A centralized, transparent digital platform for college students to lodge academic and campus grievances, submit facility feedback, and track resolution lifecycles in real time.
        </p>
        <div class="hero-actions">
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">
            <span>Student Portal</span> &rarr;
          </a>
          <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-teal">
            <span>Register Account</span>
          </a>
          <a href="${pageContext.request.contextPath}/admin-login.jsp" class="btn btn-outline-white">
            <span>Staff / Admin Login</span>
          </a>
        </div>
      </div>

      <div class="hero-card-preview">
        <h3 style="color: #ffffff; margin-bottom: 1rem; font-size: 1.15rem;">Transparency &amp; Governance</h3>
        <div class="preview-stat-grid">
          <div class="preview-stat-box">
            <div class="preview-stat-number">100%</div>
            <div class="preview-stat-label">Trackable</div>
          </div>
          <div class="preview-stat-box">
            <div class="preview-stat-number">&lt; 48h</div>
            <div class="preview-stat-label">Initial Review</div>
          </div>
          <div class="preview-stat-box">
            <div class="preview-stat-number">8+</div>
            <div class="preview-stat-label">Categories</div>
          </div>
          <div class="preview-stat-box">
            <div class="preview-stat-number">5-Star</div>
            <div class="preview-stat-label">Facility Ratings</div>
          </div>
        </div>
        <p style="color: #94a3b8; font-size: 0.85rem; text-align: center;">
          Strict privacy controls. Only administrators and submitting students can inspect case records.
        </p>
      </div>
    </div>
  </section>

  <!-- Alerts if redirected with messages -->
  <div style="max-width: 1200px; margin: 1.5rem auto -2rem; padding: 0 2rem; width: 100%;">
    <jsp:include page="/WEB-INF/views/common/messages.jsp" />
  </div>

  <!-- Features Section -->
  <section class="features-section" id="features">
    <div class="section-header">
      <h2>Comprehensive Campus Redressal Features</h2>
      <p>Designed to deliver accountability, confidentiality, and institutional continuous improvement.</p>
    </div>

    <div class="features-grid">
      <div class="feature-card">
        <div class="feature-icon-box">✍️</div>
        <h3>Structured Grievance Filing</h3>
        <p>Lodge issues categorized across Academics, Examinations, Faculty, Infrastructure, Hostel, Transport, Library, and more, complete with priority indicators.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon-box">⏱️</div>
        <h3>Live Resolution Tracking</h3>
        <p>Follow your submission through each step: <em>Submitted &rarr; Under Review &rarr; In Progress &rarr; Resolved or Rejected</em>, with date-stamped action logs.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon-box">💬</div>
        <h3>Official Administrative Responses</h3>
        <p>Receive authoritative responses directly from departmental heads and grievance committee officers assigned to your specific ticket.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon-box">⭐</div>
        <h3>Campus Facility Feedback</h3>
        <p>Rate campus Wi-Fi, hostel facilities, laboratory equipment, and cafeteria hygiene using an interactive 1-to-5 star rating system.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon-box">🛡️</div>
        <h3>Role-Based Access Control</h3>
        <p>Enterprise session protection ensures that students cannot access other students' files or administrative controls.</p>
      </div>

      <div class="feature-card">
        <div class="feature-icon-box">📊</div>
        <h3>Administrative Analytics</h3>
        <p>College executives monitor resolution times, category distribution, and facility satisfaction through data-rich visual summaries.</p>
      </div>
    </div>
  </section>

  <!-- Redressal Guidelines Section -->
  <section class="features-section" id="guidelines" style="background-color: #ffffff; border-top: 1px solid var(--border-color); border-bottom: 1px solid var(--border-color); max-width: 100%;">
    <div style="max-width: 1200px; margin: 0 auto;">
      <div class="section-header">
        <h2>How the Resolution Workflow Works</h2>
        <p>Four streamlined stages ensuring fair hearings and documented institutional accountability.</p>
      </div>

      <div class="features-grid" style="grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));">
        <div class="card" style="text-align: center; padding: 1.5rem;">
          <div style="font-size: 2rem; margin-bottom: 0.5rem;">1️⃣</div>
          <h4 style="margin-bottom: 0.5rem;">Submission</h4>
          <p style="font-size: 0.88rem; color: var(--text-muted);">Student logs in and files the grievance with category, priority, and details.</p>
        </div>
        <div class="card" style="text-align: center; padding: 1.5rem;">
          <div style="font-size: 2rem; margin-bottom: 0.5rem;">2️⃣</div>
          <h4 style="margin-bottom: 0.5rem;">Review &amp; Assignment</h4>
          <p style="font-size: 0.88rem; color: var(--text-muted);">Grievance officer assesses the matter and assigns it to the relevant faculty or department.</p>
        </div>
        <div class="card" style="text-align: center; padding: 1.5rem;">
          <div style="font-size: 2rem; margin-bottom: 0.5rem;">3️⃣</div>
          <h4 style="margin-bottom: 0.5rem;">Remediation</h4>
          <p style="font-size: 0.88rem; color: var(--text-muted);">Investigative and corrective actions are taken with progress logs updated in the audit timeline.</p>
        </div>
        <div class="card" style="text-align: center; padding: 1.5rem;">
          <div style="font-size: 2rem; margin-bottom: 0.5rem;">4️⃣</div>
          <h4 style="margin-bottom: 0.5rem;">Official Closure</h4>
          <p style="font-size: 0.88rem; color: var(--text-muted);">Written resolution rationale is posted, marked as Resolved, and student is notified.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Footer -->
  <jsp:include page="/WEB-INF/views/common/footer.jsp" />

</body>
</html>
