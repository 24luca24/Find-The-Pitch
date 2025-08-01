package com.fl.authenticationservice.service;

import com.fl.authenticationservice.entity.User;
import com.fl.authenticationservice.repository.UserRepository;
import com.fl.authenticationservice.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository
                .findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));

        System.out.println("Loaded user: " + user.getUsername());
        System.out.println("Stored password hash: " + user.getPassword());

        return new CustomUserDetails(user);
    }

}
