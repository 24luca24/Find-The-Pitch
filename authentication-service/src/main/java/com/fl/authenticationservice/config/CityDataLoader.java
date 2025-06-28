package com.fl.authenticationservice.config;

import com.fl.authenticationservice.entity.City;
import com.fl.authenticationservice.repository.CityRepository;
import org.springframework.core.io.Resource;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@Component
public class CityDataLoader {

    private final CityRepository cityRepository;

    @Value("classpath:cities_cleaned.csv")
    private Resource citiesCsv;

    public CityDataLoader(CityRepository cityRepository) {
        this.cityRepository = cityRepository;
    }

    @PostConstruct
    public void loadCities() {

        //Avoid running this code each time, unless the db is empty
        if (cityRepository.count() > 0) {
            System.out.println("Cities already loaded. Skipping...");
            return;
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(citiesCsv.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            boolean isFirst = true;
            while ((line = br.readLine()) != null) {

                //Skip header
                if (isFirst) {
                    isFirst = false;
                    continue;
                }

                String[] tokens = line.split(",");
                if (tokens.length < 7) continue;

                String name = tokens[0].trim();
                String cap = tokens[1].trim();
                String provinceAbbreviation = tokens[2].trim();
                String province = tokens[3].trim();
                String region = tokens[4].trim();
                double lat = Double.parseDouble(tokens[5].trim().replace(",", "."));
                double lon = Double.parseDouble(tokens[6].trim().replace(",", "."));

                if (!StringUtils.hasText(name)) continue;

                City city = new City();
                city.setName(name);
                city.setCap(cap);
                city.setProvinceAbbreviation(provinceAbbreviation);
                city.setProvince(province);
                city.setRegion(region);
                city.setLatitude(lat);
                city.setLongitude(lon);

                cityRepository.save(city);
            }

            System.out.println("Cities loaded.");
        } catch (Exception e) {
            System.err.println("Failed to load cities: " + e.getMessage());
        }
    }
}
