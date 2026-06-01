-- Minimal schema for SWP391 Task 1 (authentication)
CREATE DATABASE IF NOT EXISTS hrm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hrm;

CREATE TABLE IF NOT EXISTS Role (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Department (
    dep_id VARCHAR(5) PRIMARY KEY,
    dep_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Employee (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_code VARCHAR(10) UNIQUE,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    gender BOOLEAN NOT NULL DEFAULT TRUE,
    dob DATE,
    phone VARCHAR(20),
    position_title VARCHAR(100),
    image VARCHAR(255),
    paid_leave_days INT DEFAULT 1,
    start_date DATE,
    dep_id VARCHAR(5),
    role_id INT,
    status BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN NOT NULL DEFAULT TRUE,
    failed_login_count INT NOT NULL DEFAULT 0,
    locked_until DATETIME NULL,
    FOREIGN KEY (dep_id) REFERENCES Department(dep_id) ON DELETE SET NULL,
    FOREIGN KEY (role_id) REFERENCES Role(role_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ActivityLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NULL,
    action VARCHAR(50) NOT NULL,
    ip_address VARCHAR(45),
    details VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS PasswordResetToken (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    token VARCHAR(64) NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    used BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE
);

-- Sample data — set password with helper.PasswordEncryption.encryptPassword("YourPass@1")
INSERT IGNORE INTO Role (role_id, role_name) VALUES
(1, 'Admin'), (2, 'HR'), (3, 'HR Manager'), (4, 'Employee');

INSERT IGNORE INTO Department (dep_id, dep_name, description) VALUES
('IT', 'Information Technology', 'IT Department');

-- Sample admin: admin@hrm.local / Admin123!
-- INSERT IGNORE skips update if email exists; run sql/fix_admin_password.sql to reset password.
INSERT IGNORE INTO Employee (emp_code, fullname, email, password, gender, dep_id, role_id, status, email_verified)
VALUES ('EMP001', 'System Admin', 'admin@hrm.local',
        '$2a$12$yWcKwiVIObHnNgqB1fgwTuc/gJv06OnUAAV.tZ/6dsdAGzTgCb11S',
        TRUE, 'IT', 1, TRUE, TRUE);
