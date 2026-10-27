# QuizZone — Backend Implementation Plan (Spring Boot)
> **Lưu ý:** BE nằm ngoài scope chấm điểm PRM393. Tài liệu này phục vụ mục đích infrastructure — cung cấp REST API đủ để Flutter app hoạt động.  
> Repo riêng: `gr2_se1941_quizzone_be`

---

## 1. Tổng quan

**Mục đích:** Cung cấp REST API cho Flutter app QuizZone  
**Tech Stack:** Java 21 · Spring Boot 3.x · Spring Security + JWT · Spring Data JPA · MySQL 8  
**Authentication:** JWT (stateless) — access token 7 ngày  
**Scope:** CRUD đủ cho 10 chức năng Flutter app, không cần websocket, không cần file upload

---

## 2. Tech Stack chi tiết

| Thành phần | Công nghệ | Version |
|---|---|---|
| Framework | Spring Boot | 3.3.x |
| Language | Java | 21 |
| Security | Spring Security + JJWT | 0.12.x |
| ORM | Spring Data JPA (Hibernate) | — |
| Database | MySQL | 8.0 |
| Build tool | Maven | 3.x |
| API Docs | SpringDoc OpenAPI (Swagger UI) | 2.6.x |
| Test | JUnit 5 + MockMvc | — |

**`pom.xml` dependencies chính:**
```xml
<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>
  <dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
  </dependency>
  <dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.6</version>
  </dependency>
  <dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.6.0</version>
  </dependency>
  <dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
  </dependency>
</dependencies>
```

---

## 3. Cấu trúc thư mục

```
src/main/java/com/gr2/quizzone/
├── QuizZoneApplication.java
│
├── config/
│   ├── SecurityConfig.java         # Spring Security + CORS
│   └── OpenApiConfig.java          # Swagger config
│
├── security/
│   ├── JwtUtil.java                # Generate + validate JWT
│   ├── JwtAuthFilter.java          # Servlet filter gắn SecurityContext
│   └── UserDetailsServiceImpl.java # Load user từ DB
│
├── model/                          # JPA Entities
│   ├── User.java
│   ├── StudySet.java
│   ├── Flashcard.java
│   ├── QuizResult.java
│   ├── StudyProgress.java
│   ├── Notification.java
│   └── Message.java
│
├── dto/                            # Request/Response bodies
│   ├── request/
│   │   ├── LoginRequest.java
│   │   ├── RegisterRequest.java
│   │   ├── StudySetRequest.java
│   │   ├── FlashcardRequest.java
│   │   └── QuizResultRequest.java
│   └── response/
│       ├── AuthResponse.java
│       ├── StudySetResponse.java
│       ├── ProgressSummaryResponse.java
│       └── ApiResponse.java        # Wrapper chung { success, message, data }
│
├── repository/                     # Spring Data JPA interfaces
│   ├── UserRepository.java
│   ├── StudySetRepository.java
│   ├── FlashcardRepository.java
│   ├── QuizResultRepository.java
│   ├── StudyProgressRepository.java
│   ├── NotificationRepository.java
│   └── MessageRepository.java
│
├── service/
│   ├── AuthService.java
│   ├── StudySetService.java
│   ├── StudyService.java
│   ├── NotificationService.java
│   └── ChatService.java
│
└── controller/
    ├── AuthController.java
    ├── StudySetController.java
    ├── StudyController.java
    ├── NotificationController.java
    ├── ProgressController.java
    └── ChatController.java
```

---

## 4. Database Schema (MySQL)

### Các bảng

```sql
-- Users
CREATE TABLE users (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  email       VARCHAR(100) UNIQUE NOT NULL,
  password    VARCHAR(255) NOT NULL,   -- BCrypt hash
  full_name   VARCHAR(100) NOT NULL,
  avatar_url  VARCHAR(255),
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Study Sets
CREATE TABLE study_sets (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(200) NOT NULL,
  description TEXT,
  subject     VARCHAR(100),            -- Chủ đề: Math, English, etc.
  owner_id    BIGINT NOT NULL,
  is_public   BOOLEAN DEFAULT FALSE,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- Flashcards
CREATE TABLE flashcards (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  study_set_id BIGINT NOT NULL,
  term        TEXT NOT NULL,           -- Mặt trước
  definition  TEXT NOT NULL,           -- Mặt sau
  image_url   VARCHAR(255),
  position    INT DEFAULT 0,
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id) ON DELETE CASCADE
);

-- Study Progress (trạng thái biết/chưa biết từng thẻ)
CREATE TABLE study_progress (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id         BIGINT NOT NULL,
  study_set_id    BIGINT NOT NULL,
  flashcard_id    BIGINT NOT NULL,
  status          ENUM('UNKNOWN', 'LEARNING', 'KNOWN') DEFAULT 'UNKNOWN',
  updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_progress (user_id, flashcard_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id),
  FOREIGN KEY (flashcard_id) REFERENCES flashcards(id)
);

-- Quiz Results
CREATE TABLE quiz_results (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id         BIGINT NOT NULL,
  study_set_id    BIGINT NOT NULL,
  score           INT NOT NULL,          -- Số câu đúng
  total_questions INT NOT NULL,
  taken_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id)
);

-- Notifications
CREATE TABLE notifications (
  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id     BIGINT NOT NULL,
  title       VARCHAR(200) NOT NULL,
  body        TEXT,
  type        VARCHAR(50),              -- STUDY_REMINDER, ACHIEVEMENT, etc.
  is_read     BOOLEAN DEFAULT FALSE,
  created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Messages (chat theo study set)
CREATE TABLE messages (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  study_set_id    BIGINT NOT NULL,
  sender_id       BIGINT NOT NULL,
  content         TEXT NOT NULL,
  sent_at         DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (study_set_id) REFERENCES study_sets(id),
  FOREIGN KEY (sender_id) REFERENCES users(id)
);
```

---

## 5. API Endpoints

> Base URL: `http://localhost:8080`  
> Tất cả endpoint (trừ `/auth/*`) yêu cầu header: `Authorization: Bearer <token>`

### Auth

| Method | Endpoint | Request Body | Response | Mô tả |
|---|---|---|---|---|
| POST | `/auth/register` | `{ email, password, fullName }` | `{ token, user }` | Đăng ký |
| POST | `/auth/login` | `{ email, password }` | `{ token, user }` | Đăng nhập |
| GET | `/auth/me` | — | `{ user }` | Lấy thông tin user hiện tại |
| PUT | `/auth/me` | `{ fullName, avatarUrl }` | `{ user }` | Cập nhật profile |

### Study Sets

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/study-sets` | Lấy danh sách (query params: `?subject=&search=&page=0&size=20`) |
| GET | `/api/study-sets/mine` | Study sets của user đang đăng nhập |
| GET | `/api/study-sets/{id}` | Chi tiết + danh sách flashcard |
| POST | `/api/study-sets` | Tạo study set mới |
| PUT | `/api/study-sets/{id}` | Cập nhật (chỉ owner) |
| DELETE | `/api/study-sets/{id}` | Xoá (chỉ owner) |
| POST | `/api/study-sets/{id}/flashcards` | Thêm flashcard vào set |
| PUT | `/api/flashcards/{id}` | Sửa flashcard |
| DELETE | `/api/flashcards/{id}` | Xoá flashcard |

### Study / Progress

| Method | Endpoint | Request Body | Mô tả |
|---|---|---|---|
| PUT | `/api/progress/{setId}` | `{ flashcardId, status: "KNOWN"\|"UNKNOWN" }` | Cập nhật trạng thái một thẻ |
| GET | `/api/progress/{setId}` | — | Lấy progress của set này (danh sách status từng thẻ) |
| GET | `/api/progress/summary` | — | Tổng hợp cho Progress Dashboard (số thẻ đã biết, quiz scores, v.v.) |
| POST | `/api/quiz-results` | `{ studySetId, score, totalQuestions }` | Lưu kết quả quiz |
| GET | `/api/quiz-results/{setId}` | — | Lịch sử quiz của set này |

### Notifications

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/notifications` | Danh sách thông báo (mới nhất trước) |
| PUT | `/api/notifications/{id}/read` | Đánh dấu đã đọc |
| PUT | `/api/notifications/read-all` | Đánh dấu tất cả đã đọc |
| GET | `/api/notifications/unread-count` | Số thông báo chưa đọc |

### Chat / Messages

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/messages/{setId}` | Lấy tin nhắn của study set (polling từ Flutter) |
| POST | `/api/messages/{setId}` | Gửi tin nhắn mới |

---

## 6. Response Format chung

Tất cả endpoints trả về cùng một wrapper:

```json
{
  "success": true,
  "message": "OK",
  "data": { ... }
}
```

Khi lỗi:
```json
{
  "success": false,
  "message": "Study set not found",
  "data": null
}
```

HTTP status codes: `200` OK · `201` Created · `400` Bad Request · `401` Unauthorized · `403` Forbidden · `404` Not Found · `500` Internal Server Error

---

## 7. JWT Auth Flow

```
Flutter App                         Spring Boot BE
    |                                    |
    |-- POST /auth/login { email, pw } ->|
    |                              [verify password BCrypt]
    |                              [generate JWT, exp: 7 ngày]
    |<-- { token: "eyJ..." } -----------|
    |                                    |
    |  (lưu token vào SharedPreferences)|
    |                                    |
    |-- GET /api/study-sets              |
    |   Authorization: Bearer eyJ... -->|
    |                              [JwtAuthFilter validates token]
    |                              [set SecurityContext]
    |<-- { success: true, data: [...] } -|
```

---

## 8. `application.properties`

```properties
# Database
spring.datasource.url=jdbc:mysql://localhost:3306/quizzone_db?createDatabaseIfNotExist=true
spring.datasource.username=root
spring.datasource.password=root
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.open-in-view=false

# JWT
jwt.secret=quizzone_secret_key_change_this_in_production_minimum_32_chars
jwt.expiration=604800000   # 7 ngày (milliseconds)

# CORS (cho phép Flutter app gọi từ emulator)
app.cors.allowed-origins=http://10.0.2.2,http://localhost
```

---

## 9. CORS Configuration

```java
// SecurityConfig.java — cho phép Flutter Android Emulator (10.0.2.2) gọi API
@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowedOriginPatterns(List.of("*"));
    config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    config.setAllowedHeaders(List.of("*"));
    config.setAllowCredentials(true);
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", config);
    return source;
}
```

---

## 10. Chạy local

```bash
# 1. Tạo database MySQL
mysql -u root -p -e "CREATE DATABASE quizzone_db;"

# 2. Clone repo BE
git clone https://github.com/<org>/gr2_se1941_quizzone_be.git
cd gr2_se1941_quizzone_be

# 3. Cập nhật application.properties với password MySQL thật

# 4. Chạy
mvn spring-boot:run

# API docs (Swagger UI)
# http://localhost:8080/swagger-ui.html
```

**Kết nối từ Flutter Android Emulator:**  
- `localhost` trong emulator = chính emulator đó, **không phải** máy host
- Dùng `http://10.0.2.2:8080` để trỏ về máy host đang chạy Spring Boot

---

## 11. Deployment (tùy chọn — không bắt buộc)

Để team test cùng nhau mà không phải chạy local:

| Option | Free tier | Phù hợp |
|---|---|---|
| **Railway** | 500 giờ/tháng | Spring Boot + MySQL trong 1 project, dễ nhất |
| **Render** | Free tier | Spring Boot riêng, connect MySQL từ nơi khác |
| **Aiven** | MySQL free 5GB | Chỉ dùng cho DB, dùng kết hợp với Railway/Render |

Sau khi deploy, thay `baseUrl` trong `api_client.dart`:
```dart
static const String baseUrl = 'https://your-app.railway.app';
```

---

## 12. Phân công BE (linh hoạt — ai có Java background thì làm)

| Phần | Nội dung |
|---|---|
| Khung project | Spring Boot init, Security, JWT, CORS, ApiResponse wrapper |
| Auth module | `User` entity, `AuthController`, `AuthService`, `JwtUtil` |
| Study Set module | `StudySet`, `Flashcard` entities + CRUD controller/service |
| Progress & Quiz | `StudyProgress`, `QuizResult` + endpoints |
| Notification & Chat | `Notification`, `Message` + polling endpoints |

---

*Tài liệu này là tham chiếu triển khai BE. Cập nhật khi có thay đổi về schema hoặc endpoint contract.*
