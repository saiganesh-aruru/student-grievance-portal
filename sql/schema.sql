-- =====================================================================
-- Database Schema for Digital Student Grievance & Feedback Portal
-- Database Name: student_grievance_portal
-- Technology: MySQL 8.x+ / 5.7+
-- =====================================================================

CREATE DATABASE IF NOT EXISTS `student_grievance_portal`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `student_grievance_portal`;

-- Drop tables in reverse order of foreign key dependency if re-initializing
DROP TABLE IF EXISTS `grievance_timeline`;
DROP TABLE IF EXISTS `feedback`;
DROP TABLE IF EXISTS `grievances`;
DROP TABLE IF EXISTS `users`;

-- ---------------------------------------------------------------------
-- Table: users
-- Stores both Student and Administrator accounts
-- ---------------------------------------------------------------------
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `student_id` VARCHAR(30) UNIQUE DEFAULT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `salt` VARCHAR(64) NOT NULL,
    `role` ENUM('STUDENT', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    `department` VARCHAR(60) DEFAULT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_users_role` (`role`),
    INDEX `idx_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Table: grievances
-- Stores student grievance submissions, status, and admin responses
-- ---------------------------------------------------------------------
CREATE TABLE `grievances` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tracking_id` VARCHAR(20) NOT NULL UNIQUE,
    `student_id` INT NOT NULL,
    `title` VARCHAR(150) NOT NULL,
    `category` ENUM(
        'Academics',
        'Examinations',
        'Faculty',
        'Infrastructure',
        'Hostel',
        'Transport',
        'Library',
        'Other'
    ) NOT NULL,
    `priority` ENUM('Low', 'Medium', 'High', 'Urgent') NOT NULL DEFAULT 'Medium',
    `department` VARCHAR(60) DEFAULT NULL,
    `description` TEXT NOT NULL,
    `status` ENUM('Submitted', 'Under Review', 'In Progress', 'Resolved', 'Rejected') NOT NULL DEFAULT 'Submitted',
    `admin_response` TEXT DEFAULT NULL,
    `resolved_by` INT DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_grievance_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_grievance_resolver` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
    INDEX `idx_grievances_student` (`student_id`),
    INDEX `idx_grievances_status` (`status`),
    INDEX `idx_grievances_category` (`category`),
    INDEX `idx_grievances_priority` (`priority`),
    INDEX `idx_grievances_tracking` (`tracking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Table: grievance_timeline
-- Tracks historical status changes and remarks for auditability
-- ---------------------------------------------------------------------
CREATE TABLE `grievance_timeline` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `grievance_id` INT NOT NULL,
    `status` VARCHAR(30) NOT NULL,
    `remarks` TEXT DEFAULT NULL,
    `updated_by` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_timeline_grievance` FOREIGN KEY (`grievance_id`) REFERENCES `grievances` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_timeline_updater` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`),
    INDEX `idx_timeline_grievance` (`grievance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Table: feedback
-- Stores general feedback on campus facilities and services with ratings
-- ---------------------------------------------------------------------
CREATE TABLE `feedback` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `student_id` INT NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `subject` VARCHAR(150) NOT NULL,
    `comments` TEXT NOT NULL,
    `rating` TINYINT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_feedback_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    INDEX `idx_feedback_student` (`student_id`),
    INDEX `idx_feedback_category` (`category`),
    INDEX `idx_feedback_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
