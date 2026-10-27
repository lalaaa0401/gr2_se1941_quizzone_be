package com.gr2.quizzone.controller;

import com.gr2.quizzone.dto.request.StudyRequest;
import com.gr2.quizzone.dto.response.ApiResponse;
import com.gr2.quizzone.model.Flashcard;
import com.gr2.quizzone.model.StudySet;
import com.gr2.quizzone.model.User;
import com.gr2.quizzone.service.StudySetService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/study-sets")
@RequiredArgsConstructor
public class StudySetController {

    private final StudySetService studySetService;

    /** GET /api/study-sets?search=&page=0&size=20 */
    @GetMapping
    public ResponseEntity<ApiResponse<Page<StudySet>>> getAll(
            @AuthenticationPrincipal User user,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(ApiResponse.ok(studySetService.getAll(user, search, page, size)));
    }

    /** GET /api/study-sets/mine */
    @GetMapping("/mine")
    public ResponseEntity<ApiResponse<List<StudySet>>> getMine(
            @AuthenticationPrincipal User user) {
        return ResponseEntity.ok(ApiResponse.ok(studySetService.getMine(user)));
    }

    /** GET /api/study-sets/{id} */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<StudySet>> getById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(studySetService.getById(id)));
    }

    /** POST /api/study-sets */
    @PostMapping
    public ResponseEntity<ApiResponse<StudySet>> create(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody StudyRequest.CreateStudySet request) {
        StudySet created = studySetService.create(user, request);
        return ResponseEntity.status(201).body(ApiResponse.ok("Tạo study set thành công", created));
    }

    /** PUT /api/study-sets/{id} */
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<StudySet>> update(
            @AuthenticationPrincipal User user,
            @PathVariable Long id,
            @RequestBody StudyRequest.CreateStudySet request) {
        return ResponseEntity.ok(ApiResponse.ok("Cập nhật thành công", studySetService.update(user, id, request)));
    }

    /** DELETE /api/study-sets/{id} */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(
            @AuthenticationPrincipal User user,
            @PathVariable Long id) {
        studySetService.delete(user, id);
        return ResponseEntity.ok(ApiResponse.ok("Đã xoá", null));
    }

    /** POST /api/study-sets/{id}/flashcards */
    @PostMapping("/{id}/flashcards")
    public ResponseEntity<ApiResponse<Flashcard>> addFlashcard(
            @AuthenticationPrincipal User user,
            @PathVariable Long id,
            @Valid @RequestBody StudyRequest.CreateFlashcard request) {
        Flashcard card = studySetService.addFlashcard(user, id, request);
        return ResponseEntity.status(201).body(ApiResponse.ok("Thêm thẻ thành công", card));
    }

    /** DELETE /api/flashcards/{id} */
    @DeleteMapping("/flashcards/{cardId}")
    public ResponseEntity<ApiResponse<Void>> deleteFlashcard(
            @AuthenticationPrincipal User user,
            @PathVariable Long cardId) {
        studySetService.deleteFlashcard(user, cardId);
        return ResponseEntity.ok(ApiResponse.ok("Đã xoá thẻ", null));
    }
}
