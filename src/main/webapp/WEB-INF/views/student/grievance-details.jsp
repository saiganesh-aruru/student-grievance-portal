<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
  String csrfToken = com.college.portal.util.CSRFUtil.getToken(session);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Grievance Details [${grievance.trackingId}] | Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="${isAdminView ? 'grievances' : 'my_grievances'}" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">Grievance Case Tracking</h2>
        </div>
        <div class="topbar-right">
          <c:choose>
            <c:when test="${isAdminView}">
              <a href="${pageContext.request.contextPath}/admin/manage-grievances" class="btn btn-outline btn-sm">
                &larr; Back to Grievances
              </a>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/student/my-grievances" class="btn btn-outline btn-sm">
                &larr; Back to My Grievances
              </a>
            </c:otherwise>
          </c:choose>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <!-- Header Overview Card -->
        <div class="card" style="margin-bottom: 2rem;">
          <div class="card-body" style="padding: 1.75rem 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem; margin-bottom: 1rem;">
              <div>
                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 0.5rem;">
                  <span style="font-family: monospace; font-size: 1.15rem; font-weight: 800; color: var(--accent); background: var(--info-bg); padding: 0.2rem 0.6rem; border-radius: var(--radius-sm);">
                    <c:out value="${grievance.trackingId}"/>
                  </span>
                  <span class="badge ${grievance.statusBadgeClass}"><c:out value="${grievance.status}"/></span>
                  <span class="badge ${grievance.priorityBadgeClass}"><c:out value="${grievance.priority}"/> Priority</span>
                </div>
                <h1 style="font-size: 1.65rem; color: var(--primary); margin-bottom: 0.35rem;">
                  <c:out value="${grievance.title}"/>
                </h1>
                <p style="color: var(--text-muted); font-size: 0.88rem;">
                  Category: <strong><c:out value="${grievance.category}"/></strong> |
                  Assigned Department: <strong><c:out value="${grievance.department}"/></strong> |
                  Submitted on: <strong><fmt:formatDate value="${grievance.createdAt}" pattern="dd MMM yyyy, hh:mm a" /></strong>
                </p>
              </div>

              <!-- Admin Quick Action Trigger -->
              <c:if test="${isAdminView}">
                <div>
                  <button type="button" class="btn btn-primary btn-sm"
                          onclick="openUpdateModal('${grievance.id}', '${grievance.trackingId}', '${grievance.status}', '${grievance.adminResponse != null ? grievance.adminResponse.replace('\'', '\\\'') : ''}', '${grievance.department}')">
                    ✏️ Update Status / Response
                  </button>
                </div>
              </c:if>
            </div>

            <!-- Student Submitter Info Box (Visible to Admin or for Student Reference) -->
            <div style="background-color: var(--bg-main); border: 1px solid var(--border-color); border-radius: var(--radius-sm); padding: 1rem 1.25rem; display: flex; flex-wrap: wrap; gap: 2rem; font-size: 0.88rem;">
              <div>
                <span style="color: var(--text-muted);">Complainant Name:</span><br>
                <strong><c:out value="${grievance.studentName}"/></strong>
              </div>
              <div>
                <span style="color: var(--text-muted);">Student ID / Roll No:</span><br>
                <strong><c:out value="${grievance.studentRollNo}"/></strong>
              </div>
              <div>
                <span style="color: var(--text-muted);">Student Department:</span><br>
                <strong><c:out value="${grievance.studentDepartment}"/></strong>
              </div>
              <div>
                <span style="color: var(--text-muted);">Complainant Email:</span><br>
                <strong><c:out value="${grievance.studentEmail}"/></strong>
              </div>
            </div>
          </div>
        </div>

        <div style="display: grid; grid-template-columns: 1.4fr 1fr; gap: 2rem; align-items: start;">
          <!-- Left Column: Description & Official Response -->
          <div style="display: flex; flex-direction: column; gap: 2rem;">
            <!-- Factual Description Card -->
            <div class="card">
              <div class="card-header">
                <h3 class="card-title">Grievance Description</h3>
              </div>
              <div class="card-body" style="font-size: 0.95rem; line-height: 1.7; white-space: pre-wrap; color: var(--text-main);"><c:out value="${grievance.description}"/></div>
            </div>

            <!-- Official Administrative Response Card -->
            <div class="card" style="border-left: 4px solid ${grievance.status == 'Resolved' ? 'var(--success)' : (grievance.status == 'Rejected' ? 'var(--danger)' : 'var(--accent)')};">
              <div class="card-header" style="background-color: #ffffff;">
                <h3 class="card-title" style="display: flex; align-items: center; gap: 8px;">
                  <span>🏛️</span> Official Administrative Response
                </h3>
              </div>
              <div class="card-body">
                <c:choose>
                  <c:when test="${not empty grievance.adminResponse}">
                    <div style="font-size: 0.95rem; line-height: 1.7; white-space: pre-wrap; color: var(--text-main); margin-bottom: 1.25rem;"><c:out value="${grievance.adminResponse}"/></div>

                    <div style="border-top: 1px solid var(--border-color); padding-top: 0.85rem; display: flex; justify-content: space-between; align-items: center; font-size: 0.82rem; color: var(--text-muted);">
                      <div>
                        Responded by: <strong><c:out value="${grievance.resolverName != null ? grievance.resolverName : 'Grievance Redressal Officer'}"/></strong>
                      </div>
                      <div>
                        Updated: <fmt:formatDate value="${grievance.updatedAt}" pattern="dd MMM yyyy, hh:mm a" />
                      </div>
                    </div>
                  </c:when>
                  <c:otherwise>
                    <div style="text-align: center; padding: 1.5rem 1rem; color: var(--text-muted);">
                      <div style="font-size: 2rem; margin-bottom: 0.5rem;">⏳</div>
                      <h4 style="font-size: 1rem; color: var(--primary); margin-bottom: 0.25rem;">Under Investigation</h4>
                      <p style="font-size: 0.85rem;">
                        No official written response has been dispatched yet. The assigned departmental redressal officer is reviewing the particulars of this case.
                      </p>
                    </div>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

          <!-- Right Column: Resolution Audit Timeline -->
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Case Resolution Timeline</h3>
            </div>
            <div class="card-body">
              <c:choose>
                <c:when test="${not empty grievance.timeline}">
                  <div class="timeline">
                    <c:forEach var="item" items="${grievance.timeline}" varStatus="status">
                      <div class="timeline-item">
                        <div class="timeline-badge ${status.last ? 'done' : ''}"></div>
                        <div class="timeline-content">
                          <div class="timeline-header">
                            <span class="timeline-status"><c:out value="${item.status}"/></span>
                            <span class="timeline-date">
                              <fmt:formatDate value="${item.createdAt}" pattern="dd MMM, hh:mm a" />
                            </span>
                          </div>
                          <div class="timeline-remarks"><c:out value="${item.remarks}"/></div>
                          <div class="timeline-author">
                            Updated by: <c:out value="${item.updaterName}"/>
                          </div>
                        </div>
                      </div>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>
                  <p style="color: var(--text-muted); font-size: 0.88rem;">No timeline events recorded yet.</p>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </main>

      <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
  </div>

  <!-- Admin Status Update Modal Window -->
  <c:if test="${isAdminView}">
    <div class="modal-overlay" id="updateGrievanceModal">
      <div class="modal-card">
        <form action="${pageContext.request.contextPath}/admin/update-grievance" method="POST">
          <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
          <input type="hidden" id="modalGrievanceId" name="grievanceId" value="${grievance.id}">

          <div class="modal-header">
            <h3>Update Grievance: <span id="modalTrackingIdDisplay" style="color: var(--accent); font-family: monospace;"></span></h3>
            <button type="button" class="modal-close" onclick="closeModal('updateGrievanceModal')">&times;</button>
          </div>

          <div class="modal-body">
            <div class="form-group">
              <label for="modalStatusSelect" class="form-label">Resolution Status <span class="required">*</span></label>
              <select id="modalStatusSelect" name="status" class="form-control" required>
                <option value="Submitted">Submitted (Under initial receipt)</option>
                <option value="Under Review">Under Review (Assessing validity)</option>
                <option value="In Progress">In Progress (Remedial action underway)</option>
                <option value="Resolved">Resolved (Matter fully resolved)</option>
                <option value="Rejected">Rejected (Inadmissible / invalid request)</option>
              </select>
            </div>

            <div class="form-group">
              <label for="modalAssignedDepartment" class="form-label">Assigned Department</label>
              <input type="text" id="modalAssignedDepartment" name="assignedDepartment" class="form-control"
                     placeholder="e.g. Computer Science & Engineering">
            </div>

            <div class="form-group">
              <label for="modalAdminResponse" class="form-label">Official Response (Visible to Student) <span class="required">*</span></label>
              <textarea id="modalAdminResponse" name="adminResponse" class="form-control" rows="4"
                        placeholder="Detail the investigation outcomes and action taken for the student..." required></textarea>
            </div>

            <div class="form-group">
              <label for="modalRemarks" class="form-label">Audit Remarks for Timeline Log</label>
              <input type="text" id="modalRemarks" name="remarks" class="form-control"
                     placeholder="e.g. Hardware replaced, re-tested by department admin">
            </div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-outline" onclick="closeModal('updateGrievanceModal')">Cancel</button>
            <button type="submit" class="btn btn-primary">Save &amp; Update Status</button>
          </div>
        </form>
      </div>
    </div>
  </c:if>

</body>
</html>
