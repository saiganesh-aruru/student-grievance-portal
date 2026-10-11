-- =====================================================================
-- Sample Demonstration Data for Student Grievance Portal
-- Database: student_grievance_portal
-- =====================================================================

USE `student_grievance_portal`;

-- Clear existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `grievance_timeline`;
TRUNCATE TABLE `feedback`;
TRUNCATE TABLE `grievances`;
TRUNCATE TABLE `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- 1. Insert Initial Users
-- Passwords:
-- Admin:   AdminPassword@123   (Salt: a1b2c3d4e5f6789012345678abcdef01)
-- Student: StudentPassword@123 (Salt: a1b2c3d4e5f6789012345678abcdef01)
-- ---------------------------------------------------------------------
INSERT INTO `users` (`id`, `full_name`, `email`, `student_id`, `password_hash`, `salt`, `role`, `department`, `phone`)
VALUES
(1, 'Dr. Sarah Mitchell', 'admin@college.edu', NULL,
 '41ff4ce90d2e3a073f20cd0d867863fccb5c779aa77d5148d169803136c5c6c7',
 'a1b2c3d4e5f6789012345678abcdef01',
 'ADMIN', 'Academic Affairs & Grievance Cell', '+91 9876500001'),

(2, 'Alex Johnson', 'alex.student@college.edu', 'CS-2023-042',
 'a215d5754b980b7c5dde14b9a710a6f10aea92f262b7703e2b5b1480c08486ec',
 'a1b2c3d4e5f6789012345678abcdef01',
 'STUDENT', 'Computer Science & Engineering', '+91 9876543210'),

(3, 'Priya Patel', 'priya.patel@college.edu', 'EC-2023-019',
 'a215d5754b980b7c5dde14b9a710a6f10aea92f262b7703e2b5b1480c08486ec',
 'a1b2c3d4e5f6789012345678abcdef01',
 'STUDENT', 'Electronics & Communication', '+91 9876543211');

-- ---------------------------------------------------------------------
-- 2. Insert Grievances
-- ---------------------------------------------------------------------
INSERT INTO `grievances` (
    `id`, `tracking_id`, `student_id`, `title`, `category`, `priority`, `department`,
    `description`, `status`, `admin_response`, `resolved_by`, `created_at`, `updated_at`
) VALUES
(1, 'GRV-2026-0001', 2,
 'Lab Computer System Crashing Frequently in Lab 3', 'Infrastructure', 'High', 'Computer Science & Engineering',
 'During our Database Systems practical session, multiple workstations in Lab 3 (specifically desks 14-20) experience random reboots when running local MySQL servers. This has caused loss of uncommitted lab work for several students.',
 'In Progress',
 'Our system administrator investigated and identified faulty RAM modules in desks 14-20. Replacements have been ordered from the hardware vendor and will be installed by Friday.',
 1,
 DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),

(2, 'GRV-2026-0002', 2,
 'Evaluation Discrepancy in Midterm Algorithm Paper', 'Academics', 'Medium', 'Computer Science & Engineering',
 'There is a totaling mistake of 6 marks in Question 4 (Dynamic Programming section) of my Midterm paper. I requested the course instructor last week but have not received an updated mark entry on the portal.',
 'Resolved',
 'The answer script has been re-verified by the department evaluation committee. The marks have been amended from 38/50 to 44/50 on the college exam portal.',
 1,
 DATE_SUB(NOW(), INTERVAL 8 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),

(3, 'GRV-2026-0003', 2,
 'Hostel Block B Hot Water Geyser Not Functioning', 'Hostel', 'Urgent', 'Hostel Office',
 'The geyser on the 2nd floor of Hostel Block B has tripped and stopped functioning for the past 3 days. With winter temperatures dropping, students are facing severe hardship.',
 'Submitted',
 NULL,
 NULL,
 DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),

(4, 'GRV-2026-0004', 3,
 'Overcrowding in College Bus Route #7', 'Transport', 'Medium', 'Transport Section',
 'Bus route #7 catering to the South City route has exceeded safe seating capacity. Students are forced to stand on the footboard during peak hours morning and evening.',
 'Under Review',
 'Grievance received. The transport manager has scheduled an inspection of route passenger counts this week to assess running an additional 32-seater shuttle.',
 1,
 DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),

(5, 'GRV-2026-0005', 3,
 'Request for Additional Reference Books in Digital Library', 'Library', 'Low', 'Central Library',
 'The library only holds two physical copies of "Computer Networks: A Systems Approach" by Peterson & Davie, which are perpetually checked out before exams.',
 'Resolved',
 'We have procured 5 additional physical copies and also acquired institutional digital campus e-book licenses accessible via the Library Web OPAC.',
 1,
 DATE_SUB(NOW(), INTERVAL 12 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY));

-- ---------------------------------------------------------------------
-- 3. Insert Grievance Timeline Records
-- ---------------------------------------------------------------------
INSERT INTO `grievance_timeline` (`grievance_id`, `status`, `remarks`, `updated_by`, `created_at`)
VALUES
(1, 'Submitted', 'Grievance registered by student.', 2, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 'Under Review', 'Forwarded to Department IT Staff for workstation diagnosis.', 1, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 'In Progress', 'Faulty hardware identified. Replacement memory units on order.', 1, DATE_SUB(NOW(), INTERVAL 2 DAY)),

(2, 'Submitted', 'Grievance registered by student.', 2, DATE_SUB(NOW(), INTERVAL 8 DAY)),
(2, 'Under Review', 'Answer script retrieved from academic archive for committee inspection.', 1, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(2, 'Resolved', 'Mark discrepancy corrected and verified on exam portal.', 1, DATE_SUB(NOW(), INTERVAL 1 DAY)),

(3, 'Submitted', 'Grievance registered by student.', 2, DATE_SUB(NOW(), INTERVAL 1 DAY)),

(4, 'Submitted', 'Grievance registered by student.', 3, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(4, 'Under Review', 'Under review with Transport Section supervisor.', 1, DATE_SUB(NOW(), INTERVAL 3 DAY)),

(5, 'Submitted', 'Grievance registered by student.', 3, DATE_SUB(NOW(), INTERVAL 12 DAY)),
(5, 'In Progress', 'Book purchase order raised with campus vendor.', 1, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(5, 'Resolved', 'Copies cataloged and made available on shelf and OPAC.', 1, DATE_SUB(NOW(), INTERVAL 7 DAY));

-- ---------------------------------------------------------------------
-- 4. Insert Student Feedback
-- ---------------------------------------------------------------------
INSERT INTO `feedback` (`student_id`, `category`, `subject`, `comments`, `rating`, `created_at`)
VALUES
(2, 'Campus Wi-Fi/IT', 'High-Speed Wi-Fi in Central Library',
 'The Wi-Fi speed and signal coverage in the central library reading halls have drastically improved this semester. Excellent research environment!', 5,
 DATE_SUB(NOW(), INTERVAL 6 DAY)),

(2, 'Mess/Canteen', 'Nutritional Diversity in Evening Canteen Menu',
 'The food quality is hygienic, but would appreciate healthier fruit juice and sandwich options instead of deep-fried snacks in the evening.', 3,
 DATE_SUB(NOW(), INTERVAL 3 DAY)),

(3, 'Laboratory', 'Microcontroller Lab Oscilloscopes and Equipment',
 'The newly inaugurated VLSI and Microcontroller Lab is very well equipped. Modern digital oscilloscopes have made experimental observation much clearer.', 5,
 DATE_SUB(NOW(), INTERVAL 9 DAY)),

(3, 'Sports & Gym', 'Gym Equipment Maintenance',
 'Two treadmills in the student fitness center have squeaking belts and need lubrication. Overall the gym is clean.', 4,
 DATE_SUB(NOW(), INTERVAL 2 DAY));
