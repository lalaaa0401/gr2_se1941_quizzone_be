package com.gr2.quizzone.dto.request;

import com.gr2.quizzone.model.StudyProgress;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

public class StudyRequest {

    @Data
    public static class CreateStudySet {
        @NotBlank private String title;
        private String description;
        private String subject;
        private Boolean isPublic = false;
    }

    @Data
    public static class CreateFlashcard {
        @NotBlank private String term;
        @NotBlank private String definition;
        private String imageUrl;
        private Integer position = 0;
    }

    @Data
    public static class UpdateProgress {
        @NotNull private Long flashcardId;
        @NotNull private StudyProgress.Status status; // UNKNOWN | LEARNING | KNOWN
    }

    @Data
    public static class SaveQuizResult {
        @NotNull private Long studySetId;
        @NotNull private Integer score;
        @NotNull private Integer totalQuestions;
    }

    @Data
    public static class SendMessage {
        @NotBlank private String content;
    }
}
