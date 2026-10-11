# Digital Student Grievance & Feedback Portal

A centralized web application designed for colleges and universities to streamline student grievance redressal and campus feedback collection. Built with **Java Servlets, JDBC, and Apache Tomcat** following the **Model-View-Controller (MVC)** architecture.

---

## 🌟 Key Features

### 👨‍🎓 Student Portal
- **User Authentication:** Secure registration and login with salted SHA-256 password hashing.
- **Submit Grievance:** File grievances by category (Academic, Infrastructure, Hostel, Administration), priority (Low, Medium, High), and department.
- **Live Status Tracking:** Visual timeline tracking for grievance progress (`SUBMITTED` ➔ `UNDER_REVIEW` ➔ `IN_PROGRESS` ➔ `RESOLVED`).
- **Campus Feedback:** Submit 1–5 star ratings and reviews for campus facilities and academic services.
- **Personal Dashboard:** Real-time stats on filed grievances, pending issues, and submitted feedback.

### 🛡️ Administrator Portal
- **Executive Dashboard:** Live metrics, grievance volume, resolution rates, and average feedback ratings.
- **Grievance Redressal:** Search, filter, and inspect grievances, assign updates, and provide official admin responses.
- **Feedback Analytics:** Monitor student ratings and suggestions across departments.

---

## 🛠️ Tech Stack

- **Backend:** Java 17, Jakarta Servlet API 6.0, JDBC (PreparedStatements)
- **Frontend:** JSP, JSTL 3.0, Vanilla CSS3, JavaScript
- **Server:** Apache Tomcat 10.1
- **Database:** Persistent JDBC with automatic zero-configuration database bootstrapping (MySQL 8 / H2 MySQL-mode)
- **Build Tool:** Apache Maven (with included Maven Wrapper)

---

## 🚀 Getting Started

### Prerequisites
- **Java 17+** installed on your system.

### Running Locally (1-Click)
1. Clone or download this repository:
   ```bash
   git clone https://github.com/saiganesh-aruru/student-grievance-portal.git
   ```
2. In the project folder, double-click:
   ```text
   start.bat
   ```
   *This automatically builds the project using the included Maven Wrapper, deploys the WAR to Tomcat, and opens the portal in your browser.*

3. The application will be accessible at:
   👉 **`http://localhost:8080/student-grievance-portal/`**

4. To stop the server when done, double-click:
   ```text
   stop.bat
   ```

---

## 🔑 Default Demonstration Accounts

| Role | Email | Password | Access |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@college.edu` | `AdminPassword@123` | Full Admin Dashboard & Resolution Controls |
| **Student** | `alex.student@college.edu` | `StudentPassword@123` | Student Dashboard & Submissions |

*(You can also register a new student account directly from the registration page).*

---

## 📁 Project Structure

```text
student-grievance-portal/
├── sql/
│   ├── schema.sql              # Relational database schema
│   └── sample_data.sql         # Demo seed data
├── src/
│   ├── main/
│   │   ├── java/com/college/portal/
│   │   │   ├── dao/            # Data Access Objects (UserDAO, GrievanceDAO, FeedbackDAO)
│   │   │   ├── filter/         # Authentication & UTF-8 Encoding Filters
│   │   │   ├── model/          # POJO models (User, Grievance, Feedback, DashboardStats)
│   │   │   ├── servlet/        # HTTP Controllers (Auth, Grievances, Feedback, Profile)
│   │   │   └── util/           # Security, DB Connection, and Validation Utilities
│   │   ├── resources/          # Database properties configuration
│   │   └── webapp/             # JSP views, CSS styling, and client-side JavaScript
├── .gitignore
├── mvnw & mvnw.cmd             # Maven Wrapper
├── pom.xml                     # Maven project configuration
├── start.bat                   # 1-click startup script
└── stop.bat                    # 1-click shutdown script
```

---

## 📄 License
This project is open-source and available for educational and academic use.
