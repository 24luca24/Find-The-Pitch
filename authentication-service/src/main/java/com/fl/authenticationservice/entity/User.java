package com.fl.authenticationservice.entity;

import com.fl.authenticationservice.enumTypes.Role;
import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    @Column(nullable = false)
    private String city;

    //Constructors
    public User() {

    }

    public User(Long id, String username, String password, String email, Role role, String city) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
        this.city = city;
    }

    //Setters and Getters

    //ID
    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

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
