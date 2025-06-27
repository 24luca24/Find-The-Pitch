package com.fl.authenticationservice.repository;

import com.fl.authenticationservice.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {

}
