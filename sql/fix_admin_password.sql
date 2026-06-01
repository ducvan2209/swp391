-- Reset admin password to Admin123! (matches schema_task1.sql)
USE hrm;

UPDATE Employee
SET password = '$2a$12$yWcKwiVIObHnNgqB1fgwTuc/gJv06OnUAAV.tZ/6dsdAGzTgCb11S',
    failed_login_count = 0,
    locked_until = NULL,
    status = TRUE,
    email_verified = TRUE
WHERE email = 'admin@hrm.local';
