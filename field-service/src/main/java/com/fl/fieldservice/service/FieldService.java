package com.fl.fieldservice.service;

import com.fl.fieldservice.dto.FieldRequestDto;
import com.fl.fieldservice.entity.Field;
import com.fl.fieldservice.entity.Image;
import com.fl.fieldservice.repository.FieldRepository;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

//Handle logic, like verifying if a field is already saved when trying to save it

@Service
public class FieldService {

    private final FieldRepository fieldRepository;

    public FieldService(FieldRepository fieldRepository) {
        this.fieldRepository = fieldRepository;
    }

    public Field addField(FieldRequestDto fieldRequestDto, List<MultipartFile> images) throws IOException {
        Field field = new Field();
        field.setName(fieldRequestDto.getName());
        field.setDescription(fieldRequestDto.getDescription());
        field.setCity(fieldRequestDto.getCity());
        field.setAddress(fieldRequestDto.getAddress());
        field.setPhone(fieldRequestDto.getPhone());
        field.setEmail(fieldRequestDto.getEmail());
        field.setWebsite(fieldRequestDto.getWebsite());
        field.setCanShower(fieldRequestDto.isCanShower());
        field.setHasParking(fieldRequestDto.isHasParking());
        field.setHasLighting(fieldRequestDto.isHasLighting());
        field.setIsFree(fieldRequestDto.isFree());
        field.setOpeningTime(fieldRequestDto.getOpeningTime());
        field.setLunchBrakeStart(fieldRequestDto.getLunchBrakeStartTime());
        field.setLunchBrakeEnd(fieldRequestDto.getLunchBrakeEndTime());
        field.setClosingTime(fieldRequestDto.getClosingTime());
        field.setPrice(fieldRequestDto.getPrice());
        field.setSurfaceType(fieldRequestDto.getSurfaceType());
        field.setPitchType(fieldRequestDto.getPitchType());
        field.setAreaType(fieldRequestDto.getAreaType());
        if(images != null && !images.isEmpty()) {
            List<Image> imageEntities = new ArrayList<>();
            for (MultipartFile file : images) {
                Image image = new Image();
                image.setData(file.getBytes());
                image.setField(field);
                imageEntities.add(image);
            }
            field.setImages(imageEntities);
        }
        field.setImages(fieldRequestDto.getImageList());

        return fieldRepository.save(field);
    }

    public Optional<Field> findById(Long fieldId) {
        return fieldRepository.findById(fieldId);
    }

    public Optional<Field> findByNameCityAddress(String fieldName, String city, String address) {
        return fieldRepository.findByNameCityAddress(fieldName, city, address);
    }
}
