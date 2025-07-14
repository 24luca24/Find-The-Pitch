package com.fl.authenticationservice.controller;

import com.fl.authenticationservice.entity.City;
import com.fl.authenticationservice.repository.CityRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/cities")
public class CityController {

    private final CityRepository cityRepository;

    public CityController(CityRepository cityRepository) {
        this.cityRepository = cityRepository;
    }

    @GetMapping("/autocomplete")
    public ResponseEntity<List<String>> autocomplete(@RequestParam String prefix) {
        if(prefix == null || prefix.isBlank()) {
            return ResponseEntity.badRequest().body(List.of());
        }
        List<City> results = cityRepository.findByNameStartingWithIgnoreCase(prefix);
        List<String> resultsCityName = new ArrayList<>();
        for (City city : results) {
            if(city.getName() != null) {
                resultsCityName.add(city.getName());
            }
        }
        return ResponseEntity.ok(resultsCityName);
    }
}
