package com.fl.fieldservice.service;

import com.fl.fieldservice.dto.FieldRequestDto;
import com.fl.fieldservice.dto.FieldUpdateDto;
import com.fl.fieldservice.entity.Field;
import com.fl.fieldservice.repository.FieldRepository;

import org.springframework.stereotype.Service;
import java.util.Optional;

//Handle logic, like verifying if a field is already saved when trying to save it

@Service
public class FieldService {

    private final FieldRepository fieldRepository;

    public FieldService(FieldRepository fieldRepository) {
        this.fieldRepository = fieldRepository;
    }

    public Optional<Field> findById(Long fieldId) {
        return fieldRepository.findById(fieldId);
    }

    public Optional<Field> findByNameCityAddress(String fieldName, String city, String address) {
        return fieldRepository.findByNameCityAddress(fieldName, city, address);
    }

    public Optional<Long> createField(FieldRequestDto dto) {
        Field field = new Field();
        field.setName(dto.getName());
        field.setCity(dto.getCity());
        field.setAddress(dto.getAddress());
        field.setPhone(dto.getPhone());
        field.setEmail(dto.getEmail());
        field.setIsFree(dto.isFree());
        field.setPitchType(dto.getPitchType());

        Field saved = fieldRepository.save(field);
        return Optional.of(saved.getId());
    }

    public void updateField(Long id, FieldUpdateDto dto) {
        Field field = fieldRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Field not found"));
        // Null-safe updates
        if (dto.getName() != null) field.setName(dto.getName());
        if (dto.getDescription() != null) field.setDescription(dto.getDescription());
        if (dto.getCity() != null) field.setCity(dto.getCity());
        if (dto.getAddress() != null) field.setAddress(dto.getAddress());
        if (dto.getPhone() != null) field.setPhone(dto.getPhone());
        if (dto.getEmail() != null) field.setEmail(dto.getEmail());
        if (dto.getWebsite() != null) field.setWebsite(dto.getWebsite());

        if (dto.getCanShower() != null) field.setCanShower(dto.getCanShower());
        if (dto.getHasParking() != null) field.setHasParking(dto.getHasParking());
        if (dto.getHasLighting() != null) field.setHasLighting(dto.getHasLighting());
        if (dto.getFree() != null) field.setIsFree(dto.getFree());

        if (dto.getOpeningTime() != null) field.setOpeningTime(dto.getOpeningTime());
        if (dto.getLunchBrakeStart() != null) field.setLunchBrakeStart(dto.getLunchBrakeStart());
        if (dto.getLunchBrakeEnd() != null) field.setLunchBrakeEnd(dto.getLunchBrakeEnd());
        if (dto.getClosingTime() != null) field.setClosingTime(dto.getClosingTime());

        if (dto.getPrice() != null) field.setPrice(dto.getPrice());
        if (dto.getSurfaceType() != null) field.setSurfaceType(dto.getSurfaceType());
        if (dto.getPitchType() != null) field.setPitchType(dto.getPitchType());
        if (dto.getAreaType() != null) field.setAreaType(dto.getAreaType());

        //Save the updated field
        fieldRepository.save(field);
    }

}
