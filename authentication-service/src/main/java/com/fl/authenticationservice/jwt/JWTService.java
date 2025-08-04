package com.fl.authenticationservice.jwt;

import com.fl.authenticationservice.entity.User;
import com.fl.authenticationservice.security.CustomUserDetails;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

//class that:
/*
    - Generate JWT tokens when a user logs in or registers
    - Validate JWT tokens when users send requests with tokens
    - Extract information from a token
 */

@Service
public class JWTService {

    @Value("${jwt.secret}") //inject value from application properties
    private String  secretKey;

    //Create JWT token using role and email
    public String generateToken(Authentication auth) {
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        User user = userDetails.getUser();

        Map<String, Object> claims = new HashMap<>();
        claims.put("role", user.getRole().toString()); // e.g., "ROLE_ADMIN"
        claims.put("email", user.getEmail());

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(user.getUsername())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 1 day
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(secretKey.getBytes());
    }


}
