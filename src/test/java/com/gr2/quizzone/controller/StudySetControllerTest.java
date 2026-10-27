package com.gr2.quizzone.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.util.Map;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@DisplayName("Study Set API Tests")
class StudySetControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;

    static String token;
    static Long createdSetId;
    static Long createdCardId;

    // Setup: đăng ký + lấy token trước khi chạy tests
    @BeforeAll
    static void setup(@Autowired MockMvc mockMvc, @Autowired ObjectMapper objectMapper) throws Exception {
        // Đăng ký user mới (dùng email khác AuthControllerTest)
        MvcResult registerResult = mockMvc.perform(post("/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "settest@quizzone.com",
                      "password": "12345678",
                      "fullName": "Set Tester" }
                """))
                .andReturn();

        String body = registerResult.getResponse().getContentAsString();
        Map<?, ?> response = objectMapper.readValue(body, Map.class);
        Map<?, ?> data = (Map<?, ?>) response.get("data");
        token = (String) data.get("token");
    }

    // ── AUTHENTICATION GUARD ─────────────────────────────────

    @Test @Order(1)
    @DisplayName("GET /api/study-sets – Không có token → 401")
    void getAll_noToken_returns401() throws Exception {
        mockMvc.perform(get("/api/study-sets"))
                .andExpect(status().isUnauthorized());  // 401 sau khi fix AuthenticationEntryPoint
    }

    // ── CREATE ───────────────────────────────────────────────

    @Test @Order(2)
    @DisplayName("POST /api/study-sets – Tạo study set thành công")
    void createStudySet_success() throws Exception {
        MvcResult result = mockMvc.perform(post("/api/study-sets")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "title": "Test Flutter Basics",
                      "description": "Bộ thẻ test",
                      "subject": "Flutter",
                      "isPublic": true }
                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.title").value("Test Flutter Basics"))
                .andExpect(jsonPath("$.data.subject").value("Flutter"))
                .andExpect(jsonPath("$.data.isPublic").value(true))
                .andExpect(jsonPath("$.data.owner.email").value("settest@quizzone.com"))
                // password KHÔNG được lộ trong owner
                .andExpect(jsonPath("$.data.owner.password").doesNotExist())
                .andReturn();

        String body = result.getResponse().getContentAsString();
        Map<?, ?> response = objectMapper.readValue(body, Map.class);
        Map<?, ?> data = (Map<?, ?>) response.get("data");
        createdSetId = Long.valueOf(data.get("id").toString());
    }

    @Test @Order(3)
    @DisplayName("POST /api/study-sets – Thiếu title → 400")
    void createStudySet_missingTitle() throws Exception {
        mockMvc.perform(post("/api/study-sets")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "description": "No title here" }
                """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    // ── READ ─────────────────────────────────────────────────

    @Test @Order(4)
    @DisplayName("GET /api/study-sets – Trả danh sách có phân trang")
    void getAll_withToken_returnsList() throws Exception {
        mockMvc.perform(get("/api/study-sets")
                .header("Authorization", "Bearer " + token)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content", hasSize(greaterThan(0))))
                .andExpect(jsonPath("$.data.totalElements").isNumber());
    }

    @Test @Order(5)
    @DisplayName("GET /api/study-sets?search=Flutter – Tìm kiếm đúng")
    void getAll_withSearch_returnsFiltered() throws Exception {
        mockMvc.perform(get("/api/study-sets")
                .header("Authorization", "Bearer " + token)
                .param("search", "Flutter"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.content[0].title").value(containsString("Flutter")));
    }

    @Test @Order(6)
    @DisplayName("GET /api/study-sets/{id} – Trả chi tiết + flashcards")
    void getById_success() throws Exception {
        mockMvc.perform(get("/api/study-sets/" + createdSetId)
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(createdSetId))
                .andExpect(jsonPath("$.data.flashcards").isArray());
    }

    @Test @Order(7)
    @DisplayName("GET /api/study-sets/999 – ID không tồn tại → 400")
    void getById_notFound() throws Exception {
        mockMvc.perform(get("/api/study-sets/999999")
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isBadRequest());
    }

    @Test @Order(8)
    @DisplayName("GET /api/study-sets/mine – Trả study sets của tôi")
    void getMine_returnsMySets() throws Exception {
        mockMvc.perform(get("/api/study-sets/mine")
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data", hasSize(greaterThan(0))))
                .andExpect(jsonPath("$.data[0].owner.email").value("settest@quizzone.com"));
    }

    // ── FLASHCARD CRUD ───────────────────────────────────────

    @Test @Order(9)
    @DisplayName("POST /api/study-sets/{id}/flashcards – Thêm thẻ thành công")
    void addFlashcard_success() throws Exception {
        MvcResult result = mockMvc.perform(post("/api/study-sets/" + createdSetId + "/flashcards")
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "term": "Widget",
                      "definition": "Thành phần cơ bản nhất trong Flutter UI",
                      "position": 0 }
                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.term").value("Widget"))
                .andExpect(jsonPath("$.data.definition").isNotEmpty())
                .andReturn();

        String body = result.getResponse().getContentAsString();
        Map<?, ?> response = objectMapper.readValue(body, Map.class);
        Map<?, ?> data = (Map<?, ?>) response.get("data");
        createdCardId = Long.valueOf(data.get("id").toString());
    }

    @Test @Order(10)
    @DisplayName("GET /api/study-sets/{id} – Sau khi thêm thẻ, cardCount = 1")
    void getById_afterAddFlashcard_cardCountUpdated() throws Exception {
        mockMvc.perform(get("/api/study-sets/" + createdSetId)
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flashcards", hasSize(1)))
                .andExpect(jsonPath("$.data.cardCount").value(1))
                .andExpect(jsonPath("$.data.flashcards[0].term").value("Widget"));
    }

    // ── UPDATE ───────────────────────────────────────────────

    @Test @Order(11)
    @DisplayName("PUT /api/study-sets/{id} – Cập nhật tiêu đề")
    void updateStudySet_success() throws Exception {
        mockMvc.perform(put("/api/study-sets/" + createdSetId)
                .header("Authorization", "Bearer " + token)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "title": "Test Flutter Basics – Updated" }
                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.title").value("Test Flutter Basics – Updated"));
    }

    // ── DELETE ───────────────────────────────────────────────

    @Test @Order(12)
    @DisplayName("DELETE /api/study-sets/flashcards/{cardId} – Xoá thẻ thành công")
    void deleteFlashcard_success() throws Exception {
        mockMvc.perform(delete("/api/study-sets/flashcards/" + createdCardId)
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test @Order(13)
    @DisplayName("DELETE /api/study-sets/{id} – Xoá set thành công")
    void deleteStudySet_success() throws Exception {
        mockMvc.perform(delete("/api/study-sets/" + createdSetId)
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test @Order(14)
    @DisplayName("DELETE /api/study-sets/{id} – Đã xoá, gọi lại → 400")
    void deleteStudySet_alreadyDeleted() throws Exception {
        mockMvc.perform(delete("/api/study-sets/" + createdSetId)
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isBadRequest());
    }
}
