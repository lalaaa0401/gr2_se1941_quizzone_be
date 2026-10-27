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
@DisplayName("Auth API Tests")
class AuthControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;

    // Token được lưu giữa các test (đăng ký → lấy token → dùng cho test sau)
    static String jwtToken;

    // ── REGISTER ────────────────────────────────────────────

    @Test @Order(1)
    @DisplayName("POST /auth/register – Đăng ký thành công")
    void register_success() throws Exception {
        mockMvc.perform(post("/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "test@quizzone.com",
                      "password": "12345678",
                      "fullName": "Test User" }
                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.token").isNotEmpty())
                .andExpect(jsonPath("$.data.email").value("test@quizzone.com"))
                .andExpect(jsonPath("$.data.userId").isNumber())
                // password KHÔNG được trả về
                .andExpect(jsonPath("$.data.password").doesNotExist());
    }

    @Test @Order(2)
    @DisplayName("POST /auth/register – Email trùng → 400")
    void register_duplicateEmail() throws Exception {
        mockMvc.perform(post("/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "test@quizzone.com",
                      "password": "12345678",
                      "fullName": "Duplicate" }
                """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.message").value(containsString("Email đã được sử dụng")));
    }

    @Test @Order(3)
    @DisplayName("POST /auth/register – Email không hợp lệ → 400")
    void register_invalidEmail() throws Exception {
        mockMvc.perform(post("/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "not-an-email",
                      "password": "12345678",
                      "fullName": "Bad Email" }
                """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test @Order(4)
    @DisplayName("POST /auth/register – Mật khẩu < 8 ký tự → 400")
    void register_shortPassword() throws Exception {
        mockMvc.perform(post("/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "short@quizzone.com",
                      "password": "1234",
                      "fullName": "Short Pass" }
                """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    // ── LOGIN ────────────────────────────────────────────────

    @Test @Order(5)
    @DisplayName("POST /auth/login – Đăng nhập thành công, lưu token")
    void login_success() throws Exception {
        MvcResult result = mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "test@quizzone.com",
                      "password": "12345678" }
                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.token").isNotEmpty())
                .andReturn();

        // Lưu token cho các test sau
        String body = result.getResponse().getContentAsString();
        Map<?, ?> response = objectMapper.readValue(body, Map.class);
        Map<?, ?> data = (Map<?, ?>) response.get("data");
        jwtToken = (String) data.get("token");
    }

    @Test @Order(6)
    @DisplayName("POST /auth/login – Sai mật khẩu → 401")
    void login_wrongPassword() throws Exception {
        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "test@quizzone.com",
                      "password": "wrongpassword" }
                """))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test @Order(7)
    @DisplayName("POST /auth/login – Email không tồn tại → 401")
    void login_unknownEmail() throws Exception {
        mockMvc.perform(post("/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "email": "nobody@quizzone.com",
                      "password": "12345678" }
                """))
                .andExpect(status().isUnauthorized());
    }

    // ── GET ME ───────────────────────────────────────────────

    @Test @Order(8)
    @DisplayName("GET /auth/me – Có token → trả thông tin user")
    void getMe_withToken() throws Exception {
        mockMvc.perform(get("/auth/me")
                .header("Authorization", "Bearer " + jwtToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.email").value("test@quizzone.com"))
                .andExpect(jsonPath("$.data.fullName").value("Test User"))
                // password KHÔNG được trả về
                .andExpect(jsonPath("$.data.password").doesNotExist());
    }

    @Test @Order(9)
    @DisplayName("GET /auth/me – Không có token → 401")
    void getMe_noToken() throws Exception {
        mockMvc.perform(get("/auth/me"))
                .andExpect(status().isUnauthorized());
    }

    @Test @Order(10)
    @DisplayName("GET /auth/me – Token sai → 401")
    void getMe_invalidToken() throws Exception {
        mockMvc.perform(get("/auth/me")
                .header("Authorization", "Bearer invalid.token.here"))
                .andExpect(status().isUnauthorized());
    }

    // ── UPDATE PROFILE ───────────────────────────────────────

    @Test @Order(11)
    @DisplayName("PUT /auth/me – Cập nhật profile thành công")
    void updateProfile_success() throws Exception {
        mockMvc.perform(put("/auth/me")
                .header("Authorization", "Bearer " + jwtToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    { "fullName": "Test User Updated",
                      "avatarUrl": "https://example.com/avatar.jpg" }
                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.fullName").value("Test User Updated"))
                .andExpect(jsonPath("$.data.avatarUrl").value("https://example.com/avatar.jpg"));
    }
}
