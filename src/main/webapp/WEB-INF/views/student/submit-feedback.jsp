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
  <title>Submit Campus Facility Feedback | Student Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

  <div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp">
      <jsp:param name="activeNav" value="submit_feedback" />
    </jsp:include>

    <div class="main-content">
      <header class="topbar">
        <div class="topbar-left">
          <button type="button" class="mobile-toggle" id="mobileToggleBtn" aria-label="Toggle navigation">☰</button>
          <h2 class="page-title">Submit Facility Feedback</h2>
        </div>
        <div class="topbar-right">
          <a href="${pageContext.request.contextPath}/student/my-feedback" class="btn btn-outline btn-sm">
            <span>&larr; My Feedback History</span>
          </a>
        </div>
      </header>

      <main class="page-container">
        <jsp:include page="/WEB-INF/views/common/messages.jsp" />

        <div style="max-width: 800px; margin: 0 auto;">
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Campus Facilities &amp; Services Rating Form</h3>
            </div>

            <div class="card-body">
              <p style="color: var(--text-muted); font-size: 0.92rem; margin-bottom: 1.5rem;">
                Your honest feedback helps the college administration evaluate living, laboratory, and infrastructure standards. Rating scores are aggregated for campus quality audits.
              </p>

              <form action="${pageContext.request.contextPath}/student/submit-feedback" method="POST" onsubmit="return validateFeedbackForm()">
                <input type="hidden" name="csrfToken" value="<%= csrfToken %>">

                <!-- Interactive 5-Star Rating Control -->
                <div class="form-group" style="background-color: var(--bg-main); padding: 1.25rem; border-radius: var(--radius-md); border: 1px solid var(--border-color); text-align: center;">
                  <label class="form-label" style="font-size: 1rem; margin-bottom: 0.75rem;">
                    Overall Experience Rating <span class="required">*</span>
                  </label>
                  <div class="star-rating" style="justify-content: center; margin-bottom: 0.5rem;">
                    <input type="radio" id="star5" name="rating" value="5">
                    <label for="star5" title="5 stars - Outstanding">★</label>
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4" title="4 stars - Good">★</label>
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3" title="3 stars - Average">★</label>
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2" title="2 stars - Fair">★</label>
                    <input type="radio" id="star1" name="rating" value="1">
                    <label for="star1" title="1 star - Poor">★</label>
                  </div>
                  <div id="ratingDescription" style="font-size: 0.9rem; min-height: 22px; color: var(--text-muted);">
                    Click a star to rate from 1 to 5
                  </div>
                </div>

                <div class="form-row">
                  <div class="form-group">
                    <label for="feedbackCategory" class="form-label">Facility / Service Category <span class="required">*</span></label>
                    <select id="feedbackCategory" name="category" class="form-control" required>
                      <option value="">-- Select Category --</option>
                      <option value="Campus Wi-Fi/IT">Campus Wi-Fi &amp; IT Infrastructure</option>
                      <option value="Hostel">Hostel Accommodation &amp; Maintenance</option>
                      <option value="Mess/Canteen">Cafeteria, Mess &amp; Food Hygiene</option>
                      <option value="Library">Central Library &amp; Reading Rooms</option>
                      <option value="Laboratory">Laboratories &amp; Technical Equipment</option>
                      <option value="Sports & Gym">Sports Complex &amp; Gym Facilities</option>
                      <option value="Transport">College Transport &amp; Bus Services</option>
                      <option value="Administration">Administrative Office Responsiveness</option>
                      <option value="Other">Other Campus Amenities</option>
                    </select>
                  </div>

                  <div class="form-group">
                    <label for="subject" class="form-label">Feedback Subject <span class="required">*</span></label>
                    <input type="text" id="subject" name="subject" class="form-control"
                           placeholder="e.g. Wi-Fi signal in Library 2nd Floor" required maxlength="150"
                           value="${param.subject != null ? param.subject : ''}">
                  </div>
                </div>

                <div class="form-group">
                  <label for="comments" class="form-label">Your Observations &amp; Constructive Suggestions <span class="required">*</span></label>
                  <textarea id="comments" name="comments" class="form-control" rows="5"
                            placeholder="Share what worked well or what specific upgrades you recommend..." required>${param.comments != null ? param.comments : ''}</textarea>
                  <div class="form-text">Minimum 5 characters. Be specific and constructive.</div>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                  <button type="submit" class="btn btn-teal">
                    <span>Submit Facility Rating</span> &rarr;
                  </button>
                  <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline">
                    Cancel
                  </a>
                </div>
              </form>
            </div>
          </div>
        </div>
      </main>

      <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
  </div>

</body>
</html>
