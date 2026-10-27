package com.gr2.quizzone.service;

import com.gr2.quizzone.dto.request.StudyRequest;
import com.gr2.quizzone.model.Flashcard;
import com.gr2.quizzone.model.StudySet;
import com.gr2.quizzone.model.User;
import com.gr2.quizzone.repository.FlashcardRepository;
import com.gr2.quizzone.repository.StudySetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class StudySetService {

    private final StudySetRepository studySetRepository;
    private final FlashcardRepository flashcardRepository;

    /** Lấy danh sách (public + của mình), có tìm kiếm */
    public Page<StudySet> getAll(User user, String search, int page, int size) {
        PageRequest pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        if (search != null && !search.isBlank()) {
            return studySetRepository.searchPublicOrOwned(user, search, pageable);
        }
        return studySetRepository.findPublicOrOwned(user, pageable);
    }

    /** Study sets của riêng user */
    public List<StudySet> getMine(User user) {
        return studySetRepository.findByOwnerOrderByCreatedAtDesc(user);
    }

    /** Chi tiết một study set */
    public StudySet getById(Long id) {
        return studySetRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Study set không tồn tại"));
    }

    /** Tạo study set mới */
    public StudySet create(User owner, StudyRequest.CreateStudySet request) {
        StudySet set = StudySet.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .subject(request.getSubject())
                .owner(owner)
                .isPublic(Boolean.TRUE.equals(request.getIsPublic()))
                .build();
        return studySetRepository.save(set);
    }

    /** Cập nhật study set (chỉ owner) */
    public StudySet update(User user, Long id, StudyRequest.CreateStudySet request) {
        StudySet set = getById(id);
        if (!set.getOwner().getId().equals(user.getId())) {
            throw new SecurityException("Bạn không có quyền chỉnh sửa study set này");
        }
        if (request.getTitle() != null)       set.setTitle(request.getTitle());
        if (request.getDescription() != null) set.setDescription(request.getDescription());
        if (request.getSubject() != null)     set.setSubject(request.getSubject());
        if (request.getIsPublic() != null)    set.setIsPublic(request.getIsPublic());
        return studySetRepository.save(set);
    }

    /** Xoá study set (chỉ owner) */
    public void delete(User user, Long id) {
        StudySet set = getById(id);
        if (!set.getOwner().getId().equals(user.getId())) {
            throw new SecurityException("Bạn không có quyền xoá study set này");
        }
        studySetRepository.delete(set);
    }

    /** Thêm flashcard vào set */
    public Flashcard addFlashcard(User user, Long setId, StudyRequest.CreateFlashcard request) {
        StudySet set = getById(setId);
        if (!set.getOwner().getId().equals(user.getId())) {
            throw new SecurityException("Chỉ owner mới có thể thêm thẻ");
        }
        Flashcard card = Flashcard.builder()
                .studySet(set)
                .term(request.getTerm())
                .definition(request.getDefinition())
                .imageUrl(request.getImageUrl())
                .position(request.getPosition())
                .build();
        return flashcardRepository.save(card);
    }

    /** Xoá flashcard */
    public void deleteFlashcard(User user, Long cardId) {
        Flashcard card = flashcardRepository.findById(cardId)
                .orElseThrow(() -> new IllegalArgumentException("Flashcard không tồn tại"));
        if (!card.getStudySet().getOwner().getId().equals(user.getId())) {
            throw new SecurityException("Chỉ owner mới có thể xoá thẻ");
        }
        flashcardRepository.delete(card);
    }
}
