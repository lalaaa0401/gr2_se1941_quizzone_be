package com.gr2.quizzone.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

public class AuthRequest {

    @Data
    public static class Login {
        @Email(message = "Email không hợp lệ")
        @NotBlank(message = "Email không được để trống")
        private String email;

        @NotBlank(message = "Mật khẩu không được để trống")
        private String password;
    }

    @Data
    public static class Register {
        @Email(message = "Email không hợp lệ")
        @NotBlank(message = "Email không được để trống")
        private String email;

        @NotBlank(message = "Mật khẩu không được để trống")
        @Size(min = 8, message = "Mật khẩu phải ít nhất 8 ký tự")
        private String password;

        @NotBlank(message = "Tên không được để trống")
        private String fullName;

        private String phone;   // optional
        private String school;  // optional
    }

    @Data
    public static class UpdateProfile {
        private String fullName;
        private String avatarUrl;
        private String phone;
        private String school;
        private String bio;
    }
}
