package com.gr2.quizzone.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "messages")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "study_set_id", nullable = false)
    @ToString.Exclude
    @JsonIgnore  // không cần trả studySet trong response message
    private StudySet studySet;

    @ManyToOne(fetch = FetchType.EAGER)  // cần sender info để hiển thị chat
    @JoinColumn(name = "sender_id", nullable = false)
    @ToString.Exclude
    @JsonIgnoreProperties({"password", "authorities", "accountNonExpired",
            "accountNonLocked", "credentialsNonExpired", "enabled"})
    private User sender;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "sent_at", updatable = false)
    private LocalDateTime sentAt;

    @PrePersist
    protected void onCreate() {
        sentAt = LocalDateTime.now();
    }
}
