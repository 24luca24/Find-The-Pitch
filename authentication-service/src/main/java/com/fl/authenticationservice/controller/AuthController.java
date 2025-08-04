package com.fl.authenticationservice.controller;

//Talks to the outside world -> handles HTTP request
/*
    - Listen for HTTP requests (from APP)
    - Accepts and parses user input
    - Calls the right method in AuthService
    - Sends a response back to the client
 */

import com.fl.authenticationservice.dto.LoginRequest;
import com.fl.authenticationservice.dto.RegisterRequest;
import com.fl.authenticationservice.jwt.JWTService;
import com.fl.authenticationservice.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final JWTService jWTService;

    private final AuthenticationManager authenticationManager;

    public AuthController(AuthService authService, JWTService jWTService, AuthenticationManager authenticationManager) {
        this.authService = authService;
        this.jWTService = jWTService;
        this.authenticationManager = authenticationManager;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody RegisterRequest request) {
        authService.register(request);
        return ResponseEntity.ok(Map.of("success", true));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jWTService.generateToken(authentication);

        return ResponseEntity.ok(Map.of("token", token));
    }
}
