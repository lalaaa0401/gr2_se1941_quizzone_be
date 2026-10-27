package com.gr2.quizzone.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

/** Trạng thái học của user với từng flashcard */
@Entity
@Table(name = "study_progress",
    uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "flashcard_id"}))
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudyProgress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @ToString.Exclude
    @JsonIgnore
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_set_id", nullable = false)
    @ToString.Exclude
    @JsonIgnore
    private StudySet studySet;

    @ManyToOne(fetch = FetchType.EAGER)   // cần thông tin thẻ để hiển thị
    @JoinColumn(name = "flashcard_id", nullable = false)
    @ToString.Exclude
    @JsonIgnoreProperties({"studySet"})  // studySet đã @JsonIgnore, phòng thủ thêm
    private Flashcard flashcard;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private Status status = Status.UNKNOWN;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum Status { UNKNOWN, LEARNING, KNOWN }
}
