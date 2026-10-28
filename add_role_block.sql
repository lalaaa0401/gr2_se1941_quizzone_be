-- ============================================================
-- Migration: thêm cột role và is_blocked vào bảng users
-- Chạy một lần trên DB đang có sẵn:
--   mysql -u root -p quizzone_db < add_role_block.sql
-- ============================================================

USE quizzone_db;

-- Thêm cột role (ENUM: USER | ADMIN, default USER)
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS role       ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
  ADD COLUMN IF NOT EXISTS is_blocked TINYINT(1)           NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS phone      VARCHAR(20)          DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS school     VARCHAR(200)         DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS bio        TEXT                 DEFAULT NULL;

-- Tạo 1 tài khoản admin mẫu (password: "admin1234")
-- BCrypt hash của "admin1234":
INSERT IGNORE INTO users (email, password, full_name, role) VALUES
  ('admin@quizzone.com',
   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lBji',
   'QuizZone Admin',
   'ADMIN');
