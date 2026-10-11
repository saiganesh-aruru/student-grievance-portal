<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="site-footer">
  <div class="footer-container">
    <div class="footer-col">
      <h3>🏛️ Grievance &amp; Redressal Cell</h3>
      <p>A centralized digital governance platform committed to prompt, transparent, and fair resolution of student grievances, facility enhancements, and institutional feedback.</p>
    </div>
    <div class="footer-col">
      <h3>Quick Links</h3>
      <ul class="footer-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Portal Home</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">Student Portal</a></li>
        <li><a href="${pageContext.request.contextPath}/admin-login.jsp">Administrative Access</a></li>
        <li><a href="${pageContext.request.contextPath}/register.jsp">New Student Registration</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h3>Grievance Categories</h3>
      <ul class="footer-links">
        <li><a href="${pageContext.request.contextPath}/login.jsp">Academic &amp; Faculty Inquiries</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">Examinations &amp; Evaluation</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">Hostel, Mess &amp; Infrastructure</a></li>
        <li><a href="${pageContext.request.contextPath}/login.jsp">Library &amp; IT Services</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h3>Support &amp; Office Hours</h3>
      <p>Student Affairs Directorate<br>
         Admin Block, Room 204<br>
         Mon - Fri: 9:00 AM - 5:00 PM<br>
         Email: grievance@college.edu</p>
    </div>
  </div>
  <div class="footer-bottom">
    &copy; <%= java.time.Year.now().getValue() %> College Student Grievance &amp; Feedback Portal. Built with Java Servlets, JDBC, and MySQL. All Rights Reserved.
  </div>
</footer>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
