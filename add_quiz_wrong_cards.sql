-- ============================================================
-- Migration: thêm bảng quiz_result_wrong_cards
-- Lưu danh sách flashcard ID trả lời sai trong mỗi quiz
-- Tương thích MySQL 5.7+
-- Chạy: mysql -u root -p quizzone_db < add_quiz_wrong_cards.sql
-- ============================================================

USE quizzone_db;

CREATE TABLE IF NOT EXISTS quiz_result_wrong_cards (
  quiz_result_id  BIGINT NOT NULL,
  flashcard_id    BIGINT NOT NULL,
  FOREIGN KEY (quiz_result_id) REFERENCES quiz_results(id) ON DELETE CASCADE,
  FOREIGN KEY (flashcard_id)   REFERENCES flashcards(id)   ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT 'Migration hoàn tất: quiz_result_wrong_cards đã được tạo.' AS result;
