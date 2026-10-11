# Digital Student Grievance & Feedback Portal

A centralized college web application built with **Java Servlets, JDBC, MySQL, HTML5, CSS3, and JavaScript** following the **Model-View-Controller (MVC)** architecture.

---

## 🚀 Quick Start Guide (Run in 3 Steps)

### Step 1: Set Up the MySQL Database
Open your MySQL client (Command Line, MySQL Workbench, or phpMyAdmin) and execute the two SQL scripts located in the `sql/` directory:
```bash
mysql -u root -p < sql/schema.sql
mysql -u root -p < sql/sample_data.sql
```
*(Or paste the contents of `schema.sql` and `sample_data.sql` directly into your SQL query editor).*

### Step 2: Configure Database Credentials
Open `src/main/resources/db.properties` and verify your local MySQL username and password:
```properties
db.url=jdbc:mysql://localhost:3306/student_grievance_portal?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8
db.username=root
db.password=your_mysql_password
```

### Step 3: Run the Application
Simply double-click the included batch script:
```text
start.bat
```
This automatically builds the project (if needed), starts Apache Tomcat, and opens your browser to:
👉 **`http://localhost:8080/student-grievance-portal/`**

To stop the server when done, double-click:
```text
stop.bat
```

---

## 🔑 Demonstration Logins for Lab Viva

The database comes pre-seeded with ready-to-test accounts:

| Role | Email / Username | Password | Purpose |
| :--- | :--- | :--- | :--- |
| **Student** | `alex.student@college.edu` | `StudentPassword@123` | Submit grievances, view tracking status, submit 5-star feedback |
| **Administrator** | `admin@college.edu` | `AdminPassword@123` | View executive analytics, update status to "Resolved", add responses |

---

## 🏗️ Architecture: MVC Pattern Explained Simply

```
      Browser (Client)
             │
             │ HTTP Request (GET / POST)
             ▼
   [ Java Servlets ]  ─── Controls Flow & Sessions (Controller)
      │          │
      │ Uses     │ Forwards Data
      ▼          ▼
  [ Models ]  [ JSPs / CSS / JS ] ─── Displays UI (View)
      ▲
      │ Queries Data
  [ DAOs (JDBC) ]  ─── PreparedStatements
      ▲
      │ SQL
  [ MySQL Database ]
```

1. **Model (`com.college.portal.model`)**: Plain Java Objects (POJOs) representing database entities (`User`, `Grievance`, `Feedback`, `DashboardStats`).
2. **View (`src/main/webapp/` & `WEB-INF/views/`)**: JSP pages with JSTL and custom responsive CSS/JS. Output escaping prevents XSS attacks.
3. **Controller (`com.college.portal.servlet`)**: Java Servlets that accept HTTP requests, validate input, interact with the DAO layer, manage session authentication, and forward to views.
4. **Data Access Object (`com.college.portal.dao`)**: Clean JDBC layer using `PreparedStatement` with try-with-resources to prevent SQL injection and connection leaks.

---

## 🎓 Lab Viva Preparation: High-Yield Questions & Answers

### 1. What is the lifecycle of a Java Servlet?
**Answer:** A servlet has three main lifecycle phases managed by the servlet container (Tomcat):
1. **`init()`**: Called once when the servlet is first loaded into memory. Used for initialization (e.g., creating DAO instances).
2. **`service()`**: Called for each incoming HTTP request. It dispatches requests to `doGet()`, `doPost()`, `doPut()`, etc., based on the HTTP method.
3. **`destroy()`**: Called once when the servlet is unloaded (server shutdown) to clean up resources.

---

### 2. What is the difference between `Statement` and `PreparedStatement` in JDBC?
**Answer:**
- **`Statement`**: Compiles the SQL query every time it is executed. It is vulnerable to **SQL Injection** if user inputs are concatenated.
- **`PreparedStatement`**: Pre-compiles the query template on the database server. Parameters are substituted using placeholders (`?`). This provides **better performance** and **guarantees SQL injection immunity** because input parameters are treated strictly as literal data, never executable SQL commands.

---

### 3. How does session management work in this portal?
**Answer:**
- Using `HttpServletRequest.getSession(true)`, Tomcat creates an `HttpSession` and sends a unique session ID cookie (`JSESSIONID`) with the `HttpOnly` flag to the browser.
- When the student or admin logs in, their authenticated `User` object and a unique `csrfToken` are stored in the server session.
- On subsequent requests, Tomcat matches the cookie to the server-side session. On logout, `session.invalidate()` destroys the session.

---

### 4. What is the difference between `RequestDispatcher.forward()` and `HttpServletResponse.sendRedirect()`?
**Answer:**
- **`forward()`**: Happens entirely on the server side. The browser URL does not change. Request attributes are preserved. Used to display a view (`.jsp`) from a servlet.
- **`sendRedirect()`**: Sends an HTTP 302 redirect response back to the client browser, telling it to issue a brand new GET request. The URL in the address bar changes. Used after successful form submissions (POST-Redirect-GET pattern) to prevent duplicate submissions on page refresh.

---

### 5. How are passwords secured in this project?
**Answer:** Passwords are never stored in plain text. We use **Salted SHA-256 Hashing**:
1. When a user registers, a unique 32-character cryptographically secure random string (`salt`) is generated via `SecureRandom`.
2. The password and salt are combined (`salt + password`) and hashed using SHA-256 via Java's `MessageDigest`.
3. The resulting hash and the salt are stored in the database. During login, the entered password is hashed with the user's stored salt and compared against the stored hash.

---

### 6. What is Cross-Site Request Forgery (CSRF) and how is it prevented?
**Answer:** CSRF is an attack where a malicious site tricks an authenticated user's browser into submitting unauthorized requests. We prevent it using **Synchronizer CSRF Tokens**: a random UUID token is generated in the user's session and included as a hidden `<input type="hidden" name="csrfToken" value="...">` in every state-changing form. The servlet validates this token before processing any POST submission.

---

### 7. How is Role-Based Authorization enforced?
**Answer:** We implemented an `AuthenticationFilter` that intercepts requests:
- URLs matching `/student/*` require an active session where `user.getRole() == Role.STUDENT`.
- URLs matching `/admin/*` require an active session where `user.getRole() == Role.ADMIN`.
- If a student tries to access an administrative page, they are blocked with an HTTP 403 Forbidden error.
- When retrieving grievance details, `GrievanceServlet` verifies that the `studentId` of the grievance matches `session.user.id`, preventing students from inspecting each other's private complaints.

---

### 8. What is the difference between `javax.servlet` and `jakarta.servlet`?
**Answer:** In Java EE 8 and earlier (Tomcat 9), the package namespace was `javax.servlet`. When Java EE transitioned to the Eclipse Foundation under Jakarta EE (Tomcat 10+), the namespace was renamed to `jakarta.servlet`. This project uses `jakarta.servlet` matching modern Tomcat 10+ standards.

---

## 📁 Project File Structure

```
student-grievance-portal/
├── pom.xml                                    # Maven configuration & dependencies
├── README.md                                  # Complete documentation & viva prep
├── start-portal.bat                           # 1-click startup script
├── stop-portal.bat                            # 1-click shutdown script
├── sql/
│   ├── schema.sql                             # Database tables, keys & constraints
│   └── sample_data.sql                        # Demonstration students, admin & tickets
└── src/
    └── main/
        ├── java/com/college/portal/
        │   ├── model/                         # User, Grievance, Feedback, Stats
        │   ├── dao/                           # UserDAO, GrievanceDAO, FeedbackDAO
        │   ├── servlet/                       # Auth, Grievance, Feedback, Dashboards
        │   ├── filter/                        # AuthenticationFilter, EncodingFilter
        │   └── util/                          # DatabaseUtil, PasswordUtil, CSRFUtil
        ├── resources/
        │   └── db.properties                  # Database connection credentials
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml                    # Session timeout & error page mappings
            │   └── views/                     # Secure internal JSPs (Student, Admin, Error)
            ├── index.jsp                      # Modern landing page
            ├── login.jsp                      # Student login
            ├── admin-login.jsp                # Administrator login
            ├── register.jsp                   # Student registration
            ├── css/                           # style.css, dashboard.css, auth.css
            └── js/                            # main.js, validation.js
```
