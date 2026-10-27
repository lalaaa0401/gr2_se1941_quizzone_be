package com.gr2.quizzone.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "study_sets")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StudySet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 100)
    private String subject;

    // EAGER: owner luôn cần khi trả StudySet (lightweight object)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "owner_id", nullable = false)
    @ToString.Exclude
    // Chặn serialize ngược từ User (User không có studySets collection nên không circular,
    // nhưng ẩn password + các trường UserDetails không cần thiết)
    @JsonIgnoreProperties({"password", "authorities", "accountNonExpired",
            "accountNonLocked", "credentialsNonExpired", "enabled"})
    private User owner;

    @Column(name = "is_public")
    @Builder.Default
    private Boolean isPublic = false;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // LAZY: flashcards chỉ load khi cần (GET detail), không load trong list
    @OneToMany(mappedBy = "studySet", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    @ToString.Exclude
    private List<Flashcard> flashcards = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    @Transient
    public int getCardCount() {
        return flashcards == null ? 0 : flashcards.size();
    }

    // Được gắn bởi service sau khi join với bảng study_progress
    // @Transient = không map DB, chỉ xuất hiện trong JSON response
    @Transient
    private Integer knownCards;

    @Transient
    private Double completionRate;
}
