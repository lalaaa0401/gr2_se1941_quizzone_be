package com.gr2.quizzone.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "flashcards")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Flashcard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_set_id", nullable = false)
    @ToString.Exclude
    @JsonIgnore   // ngăn circular: StudySet → Flashcard → StudySet → ...
    private StudySet studySet;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String term;          // Mặt trước

    @Column(nullable = false, columnDefinition = "TEXT")
    private String definition;    // Mặt sau

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "position")
    @Builder.Default
    private Integer position = 0; // Thứ tự trong bộ thẻ
}
