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
  <title>Lodge New Grievance | Digital Student Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <!-- Authenticated Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="submit_grievance" />
    </jsp:include>

    <!-- Main Content Area -->
    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">Submit a Grievance</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/student/my-grievances" class="btn btn-outline btn-sm">
            <span>&larr; My Grievances</span>
          </a>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; align-items: start;">
          <!-- Grievance Form Card -->
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Grievance Submission Details</h3>
            </div>

            <div class="card-body">
              <form action="${pageContext.request.contextPath}/student/submit-grievance" method="POST" onsubmit="return validateGrievanceForm()">
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

                <div class="form-group">
                  <label for="title" class="form-label">Grievance Subject / Title <span class="required">*</span></label>
                  <input type="text" id="title" name="title" class="form-control"
                         placeholder="e.g. Broken display projector in Room 302" required maxlength="150"
                         value="${param.title != null ? param.title : ''}">
                  <div class="form-text">Summarize the core problem concisely (maximum 150 characters).</div>
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label for="category" class="form-label">Category <span class="required">*</span></label>
                    <select id="category" name="category" class="form-control" required>
                      <option value="">-- Select Category --</option>
                      <option value="Academics">Academics</option>
                      <option value="Examinations">Examinations</option>
                      <option value="Faculty">Faculty</option>
                      <option value="Infrastructure">Infrastructure</option>
                      <option value="Hostel">Hostel</option>
                      <option value="Transport">Transport</option>
                      <option value="Library">Library</option>
                      <option value="Other">Other</option>
                    </select>
                  </div>

                  <div class="form-group">
                    <label for="priority" class="form-label">Urgency / Priority <span class="required">*</span></label>
                    <select id="priority" name="priority" class="form-control" required>
                      <option value="Low">Low (General suggestion/routine)</option>
                      <option value="Medium" selected>Medium (Standard academic/facility issue)</option>
                      <option value="High">High (Impacting course study/living comfort)</option>
                      <option value="Urgent">Urgent (Safety hazard/immediate critical impact)</option>
                    </select>
                  </div>
                </div>

                <div class="form-group">
                  <label for="department" class="form-label">Assigned Department / Branch</label>
                  <select id="department" name="department" class="form-control">
                    <option value="">-- Default to My Department (${sessionScope.user.department}) --</option>
                    <option value="Computer Science &amp; Engineering">Computer Science &amp; Engineering</option>
                    <option value="Electronics &amp; Communication">Electronics &amp; Communication</option>
                    <option value="Electrical &amp; Electronics">Electrical &amp; Electronics</option>
                    <option value="Mechanical Engineering">Mechanical Engineering</option>
                    <option value="Civil Engineering">Civil Engineering</option>
                    <option value="Information Technology">Information Technology</option>
                    <option value="Central Library">Central Library</option>
                    <option value="Hostel Office">Hostel Office</option>
                    <option value="Transport Section">Transport Section</option>
                    <option value="Examination Cell">Examination Cell</option>
                    <option value="Finance &amp; Accounts">Finance &amp; Accounts</option>
                    <option value="Administration">General Administration</option>
                  </select>
                </div>

                <div class="form-group">
                  <label for="description" class="form-label">Detailed Factual Description <span class="required">*</span></label>
                  <textarea id="description" name="description" class="form-control" rows="6"
                            placeholder="State dates, room or bus numbers, faculty course code, or relevant context..." required>${param.description != null ? param.description : ''}</textarea>
                  <div class="form-text">Minimum 10 characters. Avoid abusive language. Keep descriptions factual and constructive.</div>
                </div>

                <div style="display: flex; gap: 1rem; align-items: center; margin-top: 1.5rem;">
                  <button type="submit" class="btn btn-primary">
                    <span>Submit Official Grievance</span> &rarr;
                  </button>
                  <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline">
                    Cancel
                  </a>
                </div>
              </form>
            </div>
          </div>

          <!-- Grievance Filing Guidelines -->
          <div class="card">
            <div class="card-header">
              <h3 class="card-title" style="font-size: 1rem;">📌 Guidelines for Fast Resolution</h3>
            </div>
            <div class="card-body" style="font-size: 0.88rem; color: var(--text-muted); line-height: 1.6;">
              <ul style="padding-left: 1.25rem;">
                <li style="margin-bottom: 0.6rem;"><strong>Be Specific:</strong> Mention workstation numbers, classroom numbers, or exam dates whenever possible.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Select Correct Category:</strong> Misclassified tickets may take longer as they must be rerouted.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Priority Accuracy:</strong> Mark as <em>Urgent</em> only if immediate safety or impending deadline is at stake.</li>
                <li style="margin-bottom: 0.6rem;"><strong>Tracking:</strong> After submission, you will receive a unique tracking ID (e.g. <code>GRV-2026-0004</code>).</li>
              </ul>
              <hr style="margin: 1.25rem 0; border: none; border-top: 1px solid var(--border-color);">
              <div style="background-color: var(--info-bg); padding: 0.75rem; border-radius: var(--radius-sm); color: #0369a1; font-size: 0.82rem;">
                🔒 <strong>Confidentiality Notice:</strong> Your identity is protected and only shared with the investigating redressal officer.
              </div>
            </div>
          </div>
        </div>
      </main>

      <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
  </div>

</body>
</html>
