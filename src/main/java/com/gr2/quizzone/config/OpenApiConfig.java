package com.gr2.quizzone.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    private static final String SECURITY_SCHEME_NAME = "Bearer Authentication";

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                // ── Thông tin API ────────────────────────────────────────
                .info(new Info()
                        .title("QuizZone API")
                        .description("""
                                QuizZone – REST API cho Flutter app (PRM393 Group 2 SE1941)
                                
                                **Cách dùng:**
                                1. Gọi `POST /auth/login` để lấy token
                                2. Nhấn nút **Authorize 🔒** ở trên
                                3. Nhập token (không cần tiền tố "Bearer ")
                                4. Tất cả request sau sẽ tự gắn header Authorization
                                """)
                        .version("1.0.0"))

                // ── Áp dụng JWT cho tất cả endpoint ─────────────────────
                .addSecurityItem(new SecurityRequirement()
                        .addList(SECURITY_SCHEME_NAME))

                // ── Định nghĩa scheme JWT Bearer ─────────────────────────
                .components(new Components()
                        .addSecuritySchemes(SECURITY_SCHEME_NAME,
                                new SecurityScheme()
                                        .name(SECURITY_SCHEME_NAME)
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                                        .description("Nhập JWT token nhận từ /auth/login (không cần 'Bearer ')")
                        ));
    }
}
