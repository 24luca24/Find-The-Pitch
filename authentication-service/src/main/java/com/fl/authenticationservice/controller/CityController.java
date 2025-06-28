package com.fl.authenticationservice.controller;

import com.fl.authenticationservice.entity.City;
import com.fl.authenticationservice.repository.CityRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

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
        List<City> results = cityRepository.findByNameStartingWithIgnoreCase(prefix);
        List<String> resultsCityName = new ArrayList<>();
        for (City city : results) {
            resultsCityName.add(city.getName());
        }
        return ResponseEntity.ok(resultsCityName);
    }
}
