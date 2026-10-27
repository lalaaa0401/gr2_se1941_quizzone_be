package com.gr2.quizzone.service;

import com.gr2.quizzone.dto.request.StudyRequest;
import com.gr2.quizzone.model.*;
import com.gr2.quizzone.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StudyService {

    private final StudyProgressRepository progressRepository;
    private final QuizResultRepository quizResultRepository;
    private final NotificationRepository notificationRepository;
    private final MessageRepository messageRepository;
    private final StudySetRepository studySetRepository;
    private final FlashcardRepository flashcardRepository;

    // ── Progress ─────────────────────────────────────────────

    /** Cập nhật trạng thái một thẻ (UNKNOWN / LEARNING / KNOWN) */
    @Transactional
    public StudyProgress updateProgress(User user, Long setId, StudyRequest.UpdateProgress request) {
        Flashcard card = flashcardRepository.findById(request.getFlashcardId())
                .orElseThrow(() -> new IllegalArgumentException("Flashcard không tồn tại"));
        StudySet set = studySetRepository.findById(setId)
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại"));

        StudyProgress progress = progressRepository.findByUserAndFlashcard(user, card)
                .orElseGet(() -> StudyProgress.builder()
                        .user(user).studySet(set).flashcard(card).build());

        progress.setStatus(request.getStatus());
        return progressRepository.save(progress);
    }

    /** Lấy progress của user trong một set */
    public List<StudyProgress> getProgressBySet(User user, Long setId) {
        StudySet set = studySetRepository.findById(setId)
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại"));
        return progressRepository.findByUserAndStudySet(user, set);
    }

    // ── Quiz Results ─────────────────────────────────────────

    /** Lưu kết quả quiz sau khi hoàn thành */
    public QuizResult saveQuizResult(User user, StudyRequest.SaveQuizResult request) {
        StudySet set = studySetRepository.findById(request.getStudySetId())
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại"));

        QuizResult result = QuizResult.builder()
                .user(user).studySet(set)
                .score(request.getScore())
                .totalQuestions(request.getTotalQuestions())
                .build();
        QuizResult saved = quizResultRepository.save(result);

        // Tự động tạo notification sau khi hoàn thành quiz
        createNotification(user, "Quiz hoàn thành!",
                String.format("Bạn đạt %d/%d câu đúng trong '%s'",
                        request.getScore(), request.getTotalQuestions(), set.getTitle()),
                "ACHIEVEMENT");

        return saved;
    }

    /** Lịch sử quiz của user trong một set */
    public List<QuizResult> getQuizHistory(User user, Long setId) {
        StudySet set = studySetRepository.findById(setId)
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại"));
        return quizResultRepository.findByUserAndStudySetOrderByTakenAtDesc(user, set);
    }

    // ── Progress Dashboard Summary ───────────────────────────

    /** Tổng hợp cho Progress Dashboard (fl_chart) */
    public Map<String, Object> getProgressSummary(User user) {
        long totalKnown = progressRepository.countAllKnownCards(user);
        long totalQuizzes = quizResultRepository.countByUser(user);
        double avgScore = quizResultRepository.avgScorePercentage(user);
        long totalSets = studySetRepository.findByOwnerOrderByCreatedAtDesc(user).size();

        // currentStreak: đếm số ngày liên tiếp (kể từ hôm nay lùi về) user có ít nhất 1 thẻ học
        int streak = 0;
        LocalDate today = LocalDate.now();
        for (int i = 0; i < 365; i++) {
            LocalDate day = today.minusDays(i);
            LocalDateTime from = day.atStartOfDay();
            LocalDateTime to = day.plusDays(1).atStartOfDay();
            if (progressRepository.hasActivityBetween(user, from, to)) {
                streak++;
            } else {
                break; // chuỗi bị gián đoạn
            }
        }

        // weeklyActivity: 7 ngày (T2->CN) theo tuần hiện tại
        LocalDate monday = today.with(DayOfWeek.MONDAY);
        String[] dayLabels = {"T2", "T3", "T4", "T5", "T6", "T7", "CN"};
        List<Map<String, Object>> weeklyActivity = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            LocalDate day = monday.plusDays(i);
            LocalDateTime from = day.atStartOfDay();
            LocalDateTime to = day.plusDays(1).atStartOfDay();
            long cardsStudied = progressRepository.countCardsStudiedBetween(user, from, to);
            Map<String, Object> entry = new LinkedHashMap<>();
            entry.put("day", dayLabels[i]);
            entry.put("cardsStudied", cardsStudied);
            weeklyActivity.add(entry);
        }

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("totalKnownCards", totalKnown);
        summary.put("totalQuizzesTaken", totalQuizzes);
        summary.put("avgScorePercentage", Math.round(avgScore * 10.0) / 10.0);
        summary.put("totalStudySets", totalSets);
        summary.put("currentStreak", streak);
        summary.put("weeklyActivity", weeklyActivity);
        return summary;
    }

    /** Tiến độ từng bộ học: knownCards / totalCards cho Progress Dashboard per-set section */
    public List<Map<String, Object>> getProgressPerSet(User user) {
        List<StudySet> studiedSets = progressRepository.findDistinctStudySetsByUser(user);
        return studiedSets.stream().map(set -> {
            long known = progressRepository.countKnownCards(user, set);
            long total = flashcardRepository.findByStudySetOrderByPosition(set).size();
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("studySetId", set.getId());
            item.put("studySetTitle", set.getTitle());
            item.put("subject", set.getSubject());
            item.put("knownCards", known);
            item.put("totalCards", total);
            return item;
        }).collect(Collectors.toList());
    }

    // ── Notifications ────────────────────────────────────────

    public List<Notification> getNotifications(User user) {
        return notificationRepository.findByUserOrderByCreatedAtDesc(user);
    }

    public long getUnreadCount(User user) {
        return notificationRepository.countByUserAndIsReadFalse(user);
    }

    @Transactional
    public void markNotificationRead(User user, Long notifId) {
        Notification notif = notificationRepository.findById(notifId)
                .orElseThrow(() -> new IllegalArgumentException("Notification không tồn tại"));
        if (notif.getUser().getId().equals(user.getId())) {
            notif.setIsRead(true);
            notificationRepository.save(notif);
        }
    }

    @Transactional
    public void markAllRead(User user) {
        notificationRepository.markAllReadByUser(user);
    }

    public void createNotification(User user, String title, String body, String type) {
        Notification notif = Notification.builder()
                .user(user).title(title).body(body).type(type).build();
        notificationRepository.save(notif);
    }

    // ── Chat / Messages ──────────────────────────────────────

    /** Lấy 50 tin nhắn mới nhất của study set (polling từ Flutter) */
    public List<Message> getMessages(Long setId) {
        StudySet set = studySetRepository.findById(setId)
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại"));
        return messageRepository.findByStudySetOrderBySentAtDesc(set, PageRequest.of(0, 50));
    }

    /** Gửi tin nhắn mới */
    public Message sendMessage(User sender, Long setId, StudyRequest.SendMessage request) {
        StudySet set = studySetRepository.findById(setId)
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại"));
        Message msg = Message.builder()
                .studySet(set).sender(sender).content(request.getContent()).build();
        return messageRepository.save(msg);
    }
}
