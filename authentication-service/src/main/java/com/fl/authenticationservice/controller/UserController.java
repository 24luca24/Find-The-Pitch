package com.fl.authenticationservice.controller;

import com.fl.authenticationservice.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping("/check-username")
    public ResponseEntity<String> checkUsername(@RequestParam String name) {
        try {
            boolean exist = userRepository.existsByUsername(name);
            return ResponseEntity.ok(Boolean.toString(!exist));
        } catch (Exception e) {
            e.printStackTrace();  // log to console
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }
}
