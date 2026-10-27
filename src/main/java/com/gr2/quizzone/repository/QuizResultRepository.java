package com.gr2.quizzone.repository;

import com.gr2.quizzone.model.QuizResult;
import com.gr2.quizzone.model.StudySet;
import com.gr2.quizzone.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuizResultRepository extends JpaRepository<QuizResult, Long> {

    List<QuizResult> findByUserAndStudySetOrderByTakenAtDesc(User user, StudySet studySet);

    // 5 quiz gần nhất của user (cho /api/quiz-results/mine)
    List<QuizResult> findTop5ByUserOrderByTakenAtDesc(User user);

    // Điểm trung bình quiz của user
    @Query("SELECT COALESCE(AVG(r.score * 100.0 / r.totalQuestions), 0) FROM QuizResult r WHERE r.user = :user")
    double avgScorePercentage(@Param("user") User user);

    long countByUser(User user);
}
