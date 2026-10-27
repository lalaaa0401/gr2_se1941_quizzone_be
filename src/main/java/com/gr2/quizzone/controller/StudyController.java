package com.gr2.quizzone.controller;

import com.gr2.quizzone.dto.request.StudyRequest;
import com.gr2.quizzone.dto.response.ApiResponse;
import com.gr2.quizzone.model.*;
import com.gr2.quizzone.service.StudyService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class StudyController {

    private final StudyService studyService;

    // ── Progress ─────────────────────────────────────────────

    /** PUT /api/progress/{setId} — Cập nhật trạng thái một thẻ */
    @PutMapping("/api/progress/{setId}")
    public ResponseEntity<ApiResponse<StudyProgress>> updateProgress(
            @AuthenticationPrincipal User user,
            @PathVariable Long setId,
            @Valid @RequestBody StudyRequest.UpdateProgress request) {
        StudyProgress p = studyService.updateProgress(user, setId, request);
        return ResponseEntity.ok(ApiResponse.ok(p));
    }

    /** GET /api/progress/{setId} — Progress của set này */
    @GetMapping("/api/progress/{setId}")
    public ResponseEntity<ApiResponse<List<StudyProgress>>> getProgress(
            @AuthenticationPrincipal User user,
            @PathVariable Long setId) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getProgressBySet(user, setId)));
    }

    /** GET /api/progress/summary — Tổng hợp cho Progress Dashboard */
    @GetMapping("/api/progress/summary")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getProgressSummary(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getProgressSummary(user)));
    }

    /** GET /api/progress/sets — Tiến độ từng bộ học (knownCards / totalCards) */
    @GetMapping("/api/progress/sets")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getProgressPerSet(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getProgressPerSet(user)));
    }

    // ── Quiz Results ─────────────────────────────────────────

    /** POST /api/quiz-results */
    @PostMapping("/api/quiz-results")
    public ResponseEntity<ApiResponse<QuizResult>> saveQuizResult(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody StudyRequest.SaveQuizResult request) {
        QuizResult result = studyService.saveQuizResult(user, request);
        return ResponseEntity.status(201).body(ApiResponse.ok("Lưu kết quả thành công", result));
    }

    /** GET /api/quiz-results/mine — 5 quiz gần nhất của user (cho Hoạt động gần đây) */
    @GetMapping("/api/quiz-results/mine")
    public ResponseEntity<ApiResponse<List<QuizResult>>> getRecentQuizResults(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getRecentQuizResults(user)));
    }

    /** GET /api/quiz-results/{setId} */
    @GetMapping("/api/quiz-results/{setId}")
    public ResponseEntity<ApiResponse<List<QuizResult>>> getQuizHistory(
            @AuthenticationPrincipal User user,
            @PathVariable Long setId) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getQuizHistory(user, setId)));
    }

    // ── Notifications ────────────────────────────────────────

    /** GET /api/notifications */
    @GetMapping("/api/notifications")
    public ResponseEntity<ApiResponse<List<Notification>>> getNotifications(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getNotifications(user)));
    }

    /** GET /api/notifications/unread-count */
    @GetMapping("/api/notifications/unread-count")
    public ResponseEntity<ApiResponse<Long>> getUnreadCount(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getUnreadCount(user)));
    }

    /** PUT /api/notifications/{id}/read */
    @PutMapping("/api/notifications/{id}/read")
    public ResponseEntity<ApiResponse<Void>> markRead(
            @AuthenticationPrincipal User user,
            @PathVariable Long id) {
        studyService.markNotificationRead(user, id);
        return ResponseEntity.ok(ApiResponse.ok("Đã đánh dấu đã đọc", null));
    }

    /** PUT /api/notifications/read-all */
    @PutMapping("/api/notifications/read-all")
    public ResponseEntity<ApiResponse<Void>> markAllRead(
            @AuthenticationPrincipal User user) {
        studyService.markAllRead(user);
        return ResponseEntity.ok(ApiResponse.ok("Đã đánh dấu tất cả đã đọc", null));
    }

    // ── Chat / Messages ──────────────────────────────────────

    /** GET /api/messages/{setId} — Polling từ Flutter */
    @GetMapping("/api/messages/{setId}")
    public ResponseEntity<ApiResponse<List<Message>>> getMessages(@PathVariable Long setId) {
        return ResponseEntity.ok(ApiResponse.ok(studyService.getMessages(setId)));
    }

    /** POST /api/messages/{setId} */
    @PostMapping("/api/messages/{setId}")
    public ResponseEntity<ApiResponse<Message>> sendMessage(
            @AuthenticationPrincipal User user,
            @PathVariable Long setId,
            @Valid @RequestBody StudyRequest.SendMessage request) {
        Message msg = studyService.sendMessage(user, setId, request);
        return ResponseEntity.status(201).body(ApiResponse.ok("Đã gửi", msg));
    }
}
