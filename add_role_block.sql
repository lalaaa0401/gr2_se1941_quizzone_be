-- ============================================================
-- Migration: thêm cột role, is_blocked, phone, school, bio vào bảng users
-- Tương thích MySQL 5.7+
-- Chạy: mysql -u root -p quizzone_db < add_role_block.sql
-- ============================================================

USE quizzone_db;

-- Dùng stored procedure để kiểm tra từng cột trước khi thêm
-- (tránh lỗi "Duplicate column name" nếu chạy lại)

DROP PROCEDURE IF EXISTS add_col_if_missing;

DELIMITER $$
CREATE PROCEDURE add_col_if_missing()
BEGIN
  -- role
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'role'
  ) THEN
    ALTER TABLE users ADD COLUMN role ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER';
  END IF;

  -- is_blocked
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'is_blocked'
  ) THEN
    ALTER TABLE users ADD COLUMN is_blocked TINYINT(1) NOT NULL DEFAULT 0;
  END IF;

  -- phone
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'phone'
  ) THEN
    ALTER TABLE users ADD COLUMN phone VARCHAR(20) DEFAULT NULL;
  END IF;

  -- school
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'school'
  ) THEN
    ALTER TABLE users ADD COLUMN school VARCHAR(200) DEFAULT NULL;
  END IF;

  -- bio
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'bio'
  ) THEN
    ALTER TABLE users ADD COLUMN bio TEXT DEFAULT NULL;
  END IF;
END$$
DELIMITER ;

CALL add_col_if_missing();
DROP PROCEDURE IF EXISTS add_col_if_missing;

-- Tạo tài khoản admin mẫu nếu chưa có (password: "admin1234")
INSERT IGNORE INTO users (email, password, full_name, role) VALUES
  ('admin@quizzone.com',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lBji',
   'QuizZone Admin',
   'ADMIN');

SELECT 'Migration hoàn tất.' AS result;
