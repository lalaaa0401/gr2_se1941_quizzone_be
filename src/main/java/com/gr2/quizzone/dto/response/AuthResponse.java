package com.gr2.quizzone.dto.response;

import com.gr2.quizzone.model.User;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AuthResponse {
    private String token;
    private Long userId;
    private String email;
    private String fullName;
    private String avatarUrl;
    private String phone;
    private String school;
    private String bio;
    private String role;   // "USER" hoặc "ADMIN"
}
