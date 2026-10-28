package com.gr2.quizzone.controller;

import com.gr2.quizzone.dto.response.ApiResponse;
import com.gr2.quizzone.model.StudySet;
import com.gr2.quizzone.model.User;
import com.gr2.quizzone.repository.QuizResultRepository;
import com.gr2.quizzone.repository.StudySetRepository;
import com.gr2.quizzone.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Admin-only endpoints. Bảo vệ bởi ROLE_ADMIN (Spring Security) +
 * @PreAuthorize là lớp bảo vệ thứ 2 cho từng method.
 */
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    private final UserRepository userRepository;
    private final StudySetRepository studySetRepository;
    private final QuizResultRepository quizResultRepository;

    /**
     * GET /api/admin/stats
     * Tổng quan hệ thống: tổng users, study sets, quiz results, users active hôm nay.
     */
    @GetMapping("/stats")
    public ResponseEntity<?> getStats() {
        long totalUsers    = userRepository.count();
        long totalSets     = studySetRepository.count();
        long totalQuizzes  = quizResultRepository.count();

        // Users active hôm nay = có quiz result trong ngày hôm nay
        LocalDateTime startOfDay = LocalDateTime.now().toLocalDate().atStartOfDay();
        long activeToday = quizResultRepository.countDistinctUsersSince(startOfDay);

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers",   totalUsers);
        stats.put("totalSets",    totalSets);
        stats.put("totalQuizzes", totalQuizzes);
        stats.put("activeToday",  activeToday);

        return ResponseEntity.ok(ApiResponse.ok("Stats loaded", stats));
    }

    /**
     * GET /api/admin/users?page=0&size=20
     * Danh sách tất cả users (phân trang, mới nhất trước).
     */
    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers(
            @RequestParam(defaultValue = "0")  int page,
            @RequestParam(defaultValue = "20") int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<User> users = userRepository.findAll(pageable);
        return ResponseEntity.ok(ApiResponse.ok("Users loaded", users));
    }

    /**
     * PUT /api/admin/users/{id}/toggle-block
     * Khoá / mở khoá tài khoản user. Không áp dụng cho admin khác.
     */
    @PutMapping("/users/{id}/toggle-block")
    public ResponseEntity<?> toggleBlock(@PathVariable Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User không tồn tại: " + id));

        if (user.getRole() == User.Role.ADMIN) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Không thể khoá tài khoản admin"));
        }

        boolean newStatus = !Boolean.TRUE.equals(user.getIsBlocked());
        user.setIsBlocked(newStatus);
        userRepository.save(user);

        String msg = newStatus ? "Đã khoá tài khoản" : "Đã mở khoá tài khoản";
        Map<String, Object> data = Map.of("userId", id, "isBlocked", newStatus);
        return ResponseEntity.ok(ApiResponse.ok(msg, data));
    }

    /**
     * GET /api/admin/study-sets?page=0&size=20
     * Tất cả study sets kể cả private (chỉ admin thấy).
     */
    @GetMapping("/study-sets")
    public ResponseEntity<?> getAllStudySets(
            @RequestParam(defaultValue = "0")  int page,
            @RequestParam(defaultValue = "20") int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<StudySet> sets = studySetRepository.findAll(pageable);
        return ResponseEntity.ok(ApiResponse.ok("Study sets loaded", sets));
    }

    /**
     * DELETE /api/admin/study-sets/{id}
     * Admin xoá bất kỳ study set nào (kể cả không phải của mình).
     */
    @DeleteMapping("/study-sets/{id}")
    public ResponseEntity<?> deleteStudySet(@PathVariable Long id) {
        StudySet set = studySetRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại: " + id));
        studySetRepository.delete(set);
        return ResponseEntity.ok(ApiResponse.ok("Đã xoá study set: " + set.getTitle(), null));
    }
}
