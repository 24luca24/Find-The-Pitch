package com.fl.authenticationservice.service;


import com.fl.authenticationservice.dto.RegisterRequest;
import com.fl.authenticationservice.entity.User;
import com.fl.authenticationservice.jwt.JWTService;
import com.fl.authenticationservice.repository.CityRepository;
import com.fl.authenticationservice.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

//Holds the brain, the business logic
//Middle layer between controller (handles HTTP requests) and database
/*
    -check if a user already exists when registering
    -saves new users to the database
    -validate user credential during login
    -encodes passwords securely
    -generates authentication token (JWT)
    -prepares the response to send back to the client
 */

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final CityRepository cityRepository;
    private final JWTService jwtService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JWTService jwtService, CityRepository cityRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.cityRepository = cityRepository;
    }

    /*
        Receive a request from the frontend (JSON payload with user info), map it
        into a user in the db (hashing the pw)
        Save the new user in the DB and generate a new JWT token for this user (return it)
     */
    public void register(RegisterRequest request) {

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username is already in use");
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email is already in use");
        }

        if (!cityRepository.existsByName(request.getCity())) {
        throw new IllegalArgumentException("City not supported.");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setEmail(request.getEmail());
        user.setRole(request.getRole());
        user.setCity(request.getCity());

        userRepository.save(user);
    }
}
