package com.gr2.quizzone.repository;

import com.gr2.quizzone.model.Message;
import com.gr2.quizzone.model.StudySet;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Long> {

    // Lấy tin nhắn mới nhất trước (Flutter polling)
    List<Message> findByStudySetOrderBySentAtDesc(StudySet studySet, Pageable pageable);
}
