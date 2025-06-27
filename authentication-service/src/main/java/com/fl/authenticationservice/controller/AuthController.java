package com.fl.authenticationservice.controller;

//Talks to the outside world -> handles HTTP request
/*
    -Listen for HTTP requests (from APP)
    -Accepts and parses user input
    -Calls the right method in AuthService
    -Sends a response back to the client
 */

import com.fl.authenticationservice.dto.RegisterRequest;
import com.fl.authenticationservice.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        String token = authService.register(request);
        return ResponseEntity.ok(Map.of("token", token));
    }

}
