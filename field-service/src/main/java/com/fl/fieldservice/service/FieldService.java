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
        return fieldRepository.findByNameAndCityAndAddress(fieldName, city, address);
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
        Field updated = fieldRepository.updateField(id, dto)
                .orElseThrow(() -> new RuntimeException("Field not found"));
    }
}
