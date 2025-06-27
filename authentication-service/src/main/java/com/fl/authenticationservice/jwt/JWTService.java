package com.fl.authenticationservice.jwt;

import com.fl.authenticationservice.entity.User;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

//class that:
/*
    -Generate JWT tokens when a user logs in or registers
    -Validate JWT tokens when users send requests with tokens
    -Extract information from a token
 */

@Service
public class JWTService {

    @Value("${jwt.secret}") //inject value from application properties
    private String  secretKey;

    //Create a JWT token for a given user
    public String generateToken(User user) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role",  user.getRole().toString());
        claims.put("email", user.getEmail());

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(user.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(secretKey.getBytes());
    }


}
