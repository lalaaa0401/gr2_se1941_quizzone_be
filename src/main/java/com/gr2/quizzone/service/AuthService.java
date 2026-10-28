package com.gr2.quizzone.service;

import com.gr2.quizzone.dto.request.AuthRequest;
import com.gr2.quizzone.dto.response.AuthResponse;
import com.gr2.quizzone.model.User;
import com.gr2.quizzone.repository.UserRepository;
import com.gr2.quizzone.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;

    /** Đăng ký tài khoản mới */
    public AuthResponse register(AuthRequest.Register request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email đã được sử dụng");
        }

        User user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .phone(request.getPhone())
                .school(request.getSchool())
                .build();

        userRepository.save(user);
        String token = jwtUtil.generateToken(user);
        return buildAuthResponse(token, user);
    }

    /** Đăng nhập — Spring Security validate password */
    public AuthResponse login(AuthRequest.Login request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        String token = jwtUtil.generateToken(user);
        return buildAuthResponse(token, user);
    }

    /** Cập nhật profile */
    public User updateProfile(User currentUser, AuthRequest.UpdateProfile request) {
        if (request.getFullName() != null)  currentUser.setFullName(request.getFullName());
        if (request.getAvatarUrl() != null) currentUser.setAvatarUrl(request.getAvatarUrl());
        if (request.getPhone() != null)     currentUser.setPhone(request.getPhone());
        if (request.getSchool() != null)    currentUser.setSchool(request.getSchool());
        if (request.getBio() != null)       currentUser.setBio(request.getBio());
        return userRepository.save(currentUser);
    }

    private AuthResponse buildAuthResponse(String token, User user) {
        return AuthResponse.builder()
                .token(token)
                .userId(user.getId())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .avatarUrl(user.getAvatarUrl())
                .phone(user.getPhone())
                .school(user.getSchool())
                .bio(user.getBio())
                .role(user.getRole() != null ? user.getRole().name() : "USER")
                .build();
    }
}
