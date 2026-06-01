-- Run on database `hrm` before using enhanced authentication features.
USE hrm;

ALTER TABLE Employee
    ADD COLUMN email_verified BOOLEAN NOT NULL DEFAULT TRUE,
    ADD COLUMN failed_login_count INT NOT NULL DEFAULT 0,
    ADD COLUMN locked_until DATETIME NULL;

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
