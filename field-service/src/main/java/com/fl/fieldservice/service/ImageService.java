package com.fl.fieldservice.service;

import com.fl.fieldservice.entity.Field;
import com.fl.fieldservice.entity.Image;
import com.fl.fieldservice.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class ImageService {

    private final ImageRepository imageRepository;

    @Autowired
    public ImageService(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    public List<Image> saveImages(List<MultipartFile> files, Field field) throws IOException {
        List<Image> images = new ArrayList<>();

        for (MultipartFile file : files) {
            if (!file.isEmpty()) {
                byte[] data = file.getBytes();
                Image image = new Image(data, field);
                images.add(image);
            }
        }
        return imageRepository.saveAll(images);
    }
}
