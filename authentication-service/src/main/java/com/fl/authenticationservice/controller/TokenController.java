package com.fl.authenticationservice.controller;

import com.fl.authenticationservice.dto.AccountDtoInfo;
import com.fl.authenticationservice.entity.User;
import com.fl.authenticationservice.security.CustomUserDetails;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/token")
public class TokenController {

    @GetMapping("/accountInfo")
    public ResponseEntity<AccountDtoInfo> getAccountInfo(Authentication auth) {
        if(auth == null || !auth.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        CustomUserDetails customUserDetails = (CustomUserDetails) auth.getPrincipal();
        User user = customUserDetails.getUser();

        AccountDtoInfo dto = new AccountDtoInfo(user.getUsername(), user.getEmail());

        return ResponseEntity.ok(dto);
    }
}
