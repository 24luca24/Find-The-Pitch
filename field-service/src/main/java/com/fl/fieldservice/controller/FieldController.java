package com.fl.fieldservice.controller;

import com.fl.fieldservice.dto.FieldRequestDto;
import com.fl.fieldservice.entity.Field;
import com.fl.fieldservice.entity.Image;
import com.fl.fieldservice.enumTypes.AreaType;
import com.fl.fieldservice.enumTypes.SurfaceType;
import com.fl.fieldservice.repository.FieldRepository;
import com.fl.fieldservice.service.FieldService;
import com.fl.fieldservice.service.ImageService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

//What your mobile app or frontend talks to via HTTP
//Uses the Service layer to return data
//Expose the service logic to the outside world using HTTP

@RestController
@RequestMapping("/api/fields")
public class FieldController {

    private FieldService fieldService;
    private ImageService imageService;

    public FieldController(FieldService fieldService, ImageService imageService) {
        this.fieldService = fieldService;
        this.imageService = imageService;
    }

    @PostMapping(value = "/addField", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Field> addField(
            @RequestPart("field") @Valid FieldRequestDto request,
            @RequestPart(value = "images", required = false) List<MultipartFile> images) throws IOException {
        Field saved = fieldService.addField(request, images);
        return ResponseEntity.ok(saved);
    }

    @PostMapping("/uploadImages")
    public ResponseEntity<?> uploadImages(@RequestParam("images") List<MultipartFile> files, @PathVariable Long fieldId) throws IOException {
        try {
            Field field = fieldService.findById(fieldId).orElseThrow(() -> new RuntimeException("Field not found"));

            List<Image> savedImages = imageService.saveImages(files, field);
            return ResponseEntity.ok(savedImages);
        } catch (IOException ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error saving images: " + ex.getMessage());
        }
    }

    @GetMapping("/checkFieldExistence")
    public ResponseEntity<Boolean> checkFieldExistence(
            @RequestParam("fieldName") String fieldName,
            @RequestParam("city") String city,
            @RequestParam("address") String address) {

        boolean exists = fieldService
                .findByNameCityAddress(fieldName, city, address)
                .isPresent();

        return ResponseEntity.ok(exists); //true if it exists, false if not
    }

    @PostMapping("/createField")
    public ResponseEntity<Map<String, Object>> createField(@RequestBody FieldRequestDto fieldDTO) {
        try {
            Long id = fieldService
                    .createField(fieldDTO.getName(), fieldDTO.getCity(), fieldDTO.getAddress(), fieldDTO.getPhone(), fieldDTO.getEmail(), fieldDTO.isFree(), fieldDTO.getPitchType())
                    .orElseThrow(() -> new RuntimeException("Error in creation of field"));

            return ResponseEntity.ok(Map.of("success", true, "data", id));
        } catch (IOException ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", ex.getMessage()));
        }
    }

    @PostMapping("/updateField")
    public ResponseEntity<Long> updateField(
    )
}
