package com.gr2.quizzone.repository;

import com.gr2.quizzone.model.Flashcard;
import com.gr2.quizzone.model.StudyProgress;
import com.gr2.quizzone.model.StudySet;
import com.gr2.quizzone.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
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

    // Lấy danh sách distinct StudySet mà user đã có progress (đã học ít nhất 1 thẻ)
    @Query("SELECT DISTINCT p.studySet FROM StudyProgress p WHERE p.user = :user")
    List<StudySet> findDistinctStudySetsByUser(@Param("user") User user);

    // Đếm số thẻ đã học (status != UNKNOWN) trong một ngày cụ thể (cho weeklyActivity)
    @Query("SELECT COUNT(p) FROM StudyProgress p WHERE p.user = :user " +
           "AND p.status != 'UNKNOWN' AND p.updatedAt >= :from AND p.updatedAt < :to")
    long countCardsStudiedBetween(@Param("user") User user,
                                  @Param("from") LocalDateTime from,
                                  @Param("to") LocalDateTime to);

    // Kiểm tra user có học ít nhất 1 thẻ trong ngày không (cho streak)
    @Query("SELECT COUNT(p) > 0 FROM StudyProgress p WHERE p.user = :user " +
           "AND p.status != 'UNKNOWN' AND p.updatedAt >= :from AND p.updatedAt < :to")
    boolean hasActivityBetween(@Param("user") User user,
                               @Param("from") LocalDateTime from,
                               @Param("to") LocalDateTime to);

    // Tìm các study set user đang học dở (có ít nhất 1 thẻ KNOWN/LEARNING),
    // sắp xếp theo thời điểm học gần nhất, dùng cho /continue
    @Query("SELECT sp.studySet FROM StudyProgress sp " +
           "WHERE sp.user.id = :userId AND sp.status != 'UNKNOWN' " +
           "GROUP BY sp.studySet.id " +
           "ORDER BY MAX(sp.updatedAt) DESC")
    List<StudySet> findInProgressSetsByUser(@Param("userId") Long userId,
                                            org.springframework.data.domain.Pageable pageable);
}
