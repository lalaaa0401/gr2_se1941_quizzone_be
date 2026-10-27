package com.gr2.quizzone.repository;

import com.gr2.quizzone.model.Flashcard;
import com.gr2.quizzone.model.StudySet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FlashcardRepository extends JpaRepository<Flashcard, Long> {
    List<Flashcard> findByStudySetOrderByPosition(StudySet studySet);
}
