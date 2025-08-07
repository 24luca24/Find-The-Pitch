package com.fl.authenticationservice.dto;

public class AccountDtoInfo {

    private String username;
    private String email;

    public AccountDtoInfo(String username, String email) {
        this.username = username;
        this.email = email;
    }

    //Getter and Setters

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
