package com.fl.authenticationservice.repository;

import com.fl.authenticationservice.entity.City;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CityRepository extends JpaRepository<City, Long> {
    boolean existsByName(String city);
    List<City> findByNameStartingWithIgnoreCase(String prefix);
}
