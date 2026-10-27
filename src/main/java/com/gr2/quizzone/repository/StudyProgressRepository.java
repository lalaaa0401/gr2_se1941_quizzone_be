package com.gr2.quizzone.repository;

import com.gr2.quizzone.model.Flashcard;
import com.gr2.quizzone.model.StudyProgress;
import com.gr2.quizzone.model.StudySet;
import com.gr2.quizzone.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface StudyProgressRepository extends JpaRepository<StudyProgress, Long> {

    Optional<StudyProgress> findByUserAndFlashcard(User user, Flashcard flashcard);

    List<StudyProgress> findByUserAndStudySet(User user, StudySet studySet);

    // Đếm số thẻ KNOWN của user trong một study set
    @Query("SELECT COUNT(p) FROM StudyProgress p WHERE p.user = :user " +
           "AND p.studySet = :set AND p.status = 'KNOWN'")
    long countKnownCards(@Param("user") User user, @Param("set") StudySet set);

    // Tổng số thẻ user đã biết trên toàn bộ sets
    @Query("SELECT COUNT(p) FROM StudyProgress p WHERE p.user = :user AND p.status = 'KNOWN'")
    long countAllKnownCards(@Param("user") User user);
}
