package com.fl.fieldservice.controller;

import com.fl.fieldservice.dto.FieldRequestDto;
import com.fl.fieldservice.dto.FieldUpdateDto;
import com.fl.fieldservice.entity.Field;
import com.fl.fieldservice.entity.Image;
import com.fl.fieldservice.service.FieldService;
import com.fl.fieldservice.service.ImageService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.swing.text.html.Option;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

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

    @PreAuthorize("hasRole('PLAYER') or hasRole('OWNER')")
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

    //API call to create a field (only mandatory fields)
    @PreAuthorize("hasRole('PLAYER') or hasRole('OWNER')")
    @PostMapping("/createField")
    public ResponseEntity<Map<String, Object>> createField(@RequestBody FieldRequestDto fieldDTO) {
        System.out.println("fieldDTO = " + fieldDTO);
        try {
            Long id = fieldService
                    .createField(fieldDTO)
                    .orElseThrow(() -> new RuntimeException("Error in creation of field"));

            System.out.println("done im in the try");
            return ResponseEntity.ok(Map.of("success", true, "data", id));
        } catch (Exception ex) {
            System.out.println("Error in creation of field. Im in the exception");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", ex.getMessage()));
        }
    }

    //API call to update a field (only optional fields)
    @PreAuthorize("hasRole('PLAYER') or hasRole('OWNER')")
    @PutMapping("/updateField/{id}")
    public ResponseEntity<?> updateField(
            @PathVariable Long id,
            @RequestBody FieldUpdateDto dto
    ) {
        try {
            fieldService.updateField(id, dto); // No return value anymore
            return ResponseEntity.ok(Map.of("success", true));
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("success", false, "message", ex.getMessage()));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "Unexpected error: " + ex.getMessage()));
        }
    }

    //Find all fields inside a city if present, otherwise return an empty list
    @PreAuthorize("hasRole('PLAYER') or hasRole('OWNER')")
    @GetMapping("/findAllByCity")
    public ResponseEntity<List<Field>> findAllByCity(
            @RequestParam("city") String city) {
        Optional<List<Field>> fields = fieldService.findAllByCity(city);
        return ResponseEntity.ok(fields.orElse(new ArrayList<>()));
    }

    //Find all fields inside a starting with a prefix if present, otherwise return an empty list
    @GetMapping("/findByNameStartingWith")
    public ResponseEntity<List<Field>> findByNameStartingWith(
            @RequestParam("fieldName") String fieldName) {
        Optional<List<Field>> fields = fieldService.findByNameStartingWith(fieldName);
        return ResponseEntity.ok(fields.orElse(new ArrayList<>()));
    }

    //Find the field yet created
    @PreAuthorize("hasRole('PLAYER') or hasRole('OWNER')")
    @GetMapping("/findOneByName")
    public ResponseEntity<Field> findOneByName(
            @RequestParam("fieldName") String fieldName) {
        Optional<Field> field = fieldService.findOneByName(fieldName);
        return field.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }
}
