package com.gr2.quizzone.repository;

import com.gr2.quizzone.model.StudySet;
import com.gr2.quizzone.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface StudySetRepository extends JpaRepository<StudySet, Long> {

    // Danh sách public + danh sách của user hiện tại
    @Query("SELECT s FROM StudySet s WHERE s.isPublic = true OR s.owner = :user ORDER BY s.createdAt DESC")
    Page<StudySet> findPublicOrOwned(@Param("user") User user, Pageable pageable);

    // Tìm kiếm theo tiêu đề hoặc chủ đề
    @Query("SELECT s FROM StudySet s WHERE (s.isPublic = true OR s.owner = :user) AND " +
           "(LOWER(s.title) LIKE LOWER(CONCAT('%', :q, '%')) OR LOWER(s.subject) LIKE LOWER(CONCAT('%', :q, '%')))")
    Page<StudySet> searchPublicOrOwned(@Param("user") User user, @Param("q") String q, Pageable pageable);

    // Study sets của riêng user
    List<StudySet> findByOwnerOrderByCreatedAtDesc(User owner);
}
