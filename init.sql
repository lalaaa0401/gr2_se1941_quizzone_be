-- ============================================================
-- QuizZone Database Init Script
-- Chạy file này một lần để khởi tạo DB và bảng
-- mysql -u root -p < init.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS quizzone_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE quizzone_db;

-- ── Users ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  email       VARCHAR(100)  UNIQUE NOT NULL,
  password    VARCHAR(255)  NOT NULL,
  full_name   VARCHAR(100)  NOT NULL,
  avatar_url  VARCHAR(255)  DEFAULT NULL,
  created_at  DATETIME      DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Study Sets ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS study_sets (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(200)  NOT NULL,
  description TEXT          DEFAULT NULL,
  subject     VARCHAR(100)  DEFAULT NULL,
  owner_id    BIGINT        NOT NULL,
  is_public   TINYINT(1)    DEFAULT 0,
  created_at  DATETIME      DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Flashcards ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS flashcards (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  study_set_id  BIGINT  NOT NULL,
  term          TEXT    NOT NULL,
  definition    TEXT    NOT NULL,
  image_url     VARCHAR(255) DEFAULT NULL,
  position      INT          DEFAULT 0,
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Study Progress ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS study_progress (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id       BIGINT  NOT NULL,
  study_set_id  BIGINT  NOT NULL,
  flashcard_id  BIGINT  NOT NULL,
  status        ENUM('UNKNOWN','LEARNING','KNOWN') DEFAULT 'UNKNOWN',
  updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_progress (user_id, flashcard_id),
  FOREIGN KEY (user_id)      REFERENCES users(id)      ON DELETE CASCADE,
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id) ON DELETE CASCADE,
  FOREIGN KEY (flashcard_id) REFERENCES flashcards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Quiz Results ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS quiz_results (
  id               BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id          BIGINT NOT NULL,
  study_set_id     BIGINT NOT NULL,
  score            INT    NOT NULL,
  total_questions  INT    NOT NULL,
  taken_at         DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)      REFERENCES users(id)      ON DELETE CASCADE,
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Notifications ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id     BIGINT       NOT NULL,
  title       VARCHAR(200) NOT NULL,
  body        TEXT         DEFAULT NULL,
  type        VARCHAR(50)  DEFAULT NULL,
  is_read     TINYINT(1)   DEFAULT 0,
  created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Messages ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS messages (
  id            BIGINT AUTO_INCREMENT PRIMARY KEY,
  study_set_id  BIGINT NOT NULL,
  sender_id     BIGINT NOT NULL,
  content       TEXT   NOT NULL,
  sent_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id)    REFERENCES users(id)      ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Seed data mẫu (tùy chọn — xoá nếu không cần)
-- ============================================================

-- User mẫu (password: "12345678" đã BCrypt)
INSERT IGNORE INTO users (email, password, full_name) VALUES
  ('test@quizzone.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Test User');

-- Study set mẫu
INSERT IGNORE INTO study_sets (title, description, subject, owner_id, is_public) VALUES
  ('English Vocabulary A1', 'Từ vựng tiếng Anh cơ bản', 'English', 1, 1),
  ('Toán Đại Cương', 'Công thức toán học cơ bản', 'Math', 1, 1);

-- Flashcard mẫu cho set 1
INSERT IGNORE INTO flashcards (study_set_id, term, definition, position) VALUES
  (1, 'Hello',   'Xin chào',  0),
  (1, 'Goodbye', 'Tạm biệt',  1),
  (1, 'Thank you', 'Cảm ơn',  2),
  (1, 'Sorry',   'Xin lỗi',   3);
