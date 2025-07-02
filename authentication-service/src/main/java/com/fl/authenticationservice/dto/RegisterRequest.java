package com.fl.authenticationservice.dto;

import com.fl.authenticationservice.enumTypes.Role;
import jakarta.validation.constraints.*;

public class RegisterRequest {

    @NotBlank
    @Size(min=3, max = 30)
    private String username;

    @NotBlank
    @Pattern(regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[-_])(?=.*\\d).{8,}$",
            message = "Password must be at least 8 characters, include a number, uppercase letter, and - or _")
    private String password;

    @NotBlank
    @Email
    private String email;

    @NotNull
    private Role role;

    @NotBlank
    private String city;

    //Constructor
    public RegisterRequest() {

    }

    public RegisterRequest(String username, String password, String email, Role role, String city) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.city = city;
    }

    //Setters and Getters

    //USERNAME
    public void setUsername(String username) {
        this.username = username;
    }
    public String getUsername() {
        return username;
    }

    //PASSWORD
    public void setPassword(String password) {
        this.password = password;
    }
    public String getPassword() {
        return password;
    }

    //EMAIL
    public void setEmail(String email) {
        this.email = email;
    }
    public String getEmail() {
        return email;
    }

    //ROLE
    public void setRole(Role role) {
        this.role = role;
    }
    public Role getRole() {
        return role;
    }

    //CITY
    public void setCity(String city) {
        this.city = city;
    }
    public String getCity() {
        return city;
    }
}

