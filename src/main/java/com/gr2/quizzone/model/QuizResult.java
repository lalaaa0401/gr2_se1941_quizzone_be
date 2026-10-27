package com.gr2.quizzone.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "quiz_results")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuizResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @ToString.Exclude
    @JsonIgnore
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "study_set_id", nullable = false)
    @ToString.Exclude
    // Chặn serialize flashcards (28+ thẻ) khi trả quiz history — chỉ cần id + title
    @JsonIgnoreProperties({"flashcards", "description", "owner"})
    private StudySet studySet;

    @Column(nullable = false)
    private Integer score;           // Số câu đúng

    @Column(name = "total_questions", nullable = false)
    private Integer totalQuestions;

    @Column(name = "taken_at", updatable = false)
    private LocalDateTime takenAt;

    @PrePersist
    protected void onCreate() {
        takenAt = LocalDateTime.now();
    }

    /** Phần trăm điểm (helper) */
    @Transient
    public double getPercentage() {
        if (totalQuestions == 0) return 0;
        return (double) score / totalQuestions * 100;
    }
}
