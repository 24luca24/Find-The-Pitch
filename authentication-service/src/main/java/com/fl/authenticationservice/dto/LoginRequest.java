package com.fl.authenticationservice.dto;

import jakarta.validation.constraints.NotBlank;

public class LoginRequest {

    @NotBlank
    private String username;

    @NotBlank
    private String password;

    //Constructors
    public LoginRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public LoginRequest() {
    }

    //Getters and Setters

    //USERNAME
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    //PASSWORD
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
}
