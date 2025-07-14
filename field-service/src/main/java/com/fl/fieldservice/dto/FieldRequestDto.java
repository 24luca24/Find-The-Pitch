package com.fl.fieldservice.dto;

import com.fl.fieldservice.entity.Image;
import com.fl.fieldservice.enumTypes.AreaType;
import com.fl.fieldservice.enumTypes.PitchType;
import com.fl.fieldservice.enumTypes.SurfaceType;
import jakarta.validation.constraints.NotBlank;

import java.time.LocalTime;
import java.util.List;

public class FieldRequestDto {

    @NotBlank
    private String name;

    private String description;

    @NotBlank
    private String city;

    @NotBlank
    private String address;

    @NotBlank
    private String phone;

    @NotBlank
    private String email;

    @NotBlank
    private String website;

    private boolean canShower;

    private boolean hasParking;

    private boolean hasLighting;

    @NotBlank
    private boolean isFree;

    @NotBlank
    private LocalTime openingTime;
    private LocalTime lunchBrakeStartTime;
    private LocalTime lunchBrakeEndTime;

    @NotBlank
    private LocalTime closingTime;

    private float price;

    private SurfaceType surfaceType;

    @NotBlank
    private PitchType pitchType;

    private AreaType areaType;

    private List<Image> imageList;

    public FieldRequestDto() {

    }

    //Getters and Setters

    //NAME
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    //DESCRIPTION
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    //CITY
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }

    //ADDRESS
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    //PHONE
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    //EMAIL
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    //WEBSITE
    public String getWebsite() {
        return website;
    }
    public void setWebsite(String website) {
        this.website = website;
    }

    //SHOWER
    public boolean isCanShower() {
        return canShower;
    }
    public void setCanShower(boolean canShower) {
        this.canShower = canShower;
    }

    //PARKING
    public boolean isHasParking() {
        return hasParking;
    }
    public void setHasParking(boolean hasParking) {
        this.hasParking = hasParking;
    }

    //LIGHTING
    public boolean isHasLighting() {
        return hasLighting;
    }
    public void setHasLighting(boolean hasLighting) {
        this.hasLighting = hasLighting;
    }

    //FREE
    public boolean isFree() {
        return isFree;
    }
    public void setFree(boolean free) {
        isFree = free;
    }

    //OPENING TIME
    public LocalTime getOpeningTime() {
        return openingTime;
    }
    public void setOpeningTime(LocalTime startTime) {
        this.openingTime = startTime;
    }

    //LUNCH BRAKE START
    public LocalTime getLunchBrakeStartTime() {
        return lunchBrakeStartTime;
    }
    public void setLunchBrakeStartTime(LocalTime lunchBrakeStartTime) {
        this.lunchBrakeStartTime = lunchBrakeStartTime;
    }

    //LUNCH BRAKE END
    public LocalTime getLunchBrakeEndTime() {
        return lunchBrakeEndTime;
    }
    public void setLunchBrakeEndTime(LocalTime lunchBrakeEndTime) {
        this.lunchBrakeEndTime = lunchBrakeEndTime;
    }

    //END TIME
    public LocalTime getClosingTime() {
        return closingTime;
    }
    public void setClosingTime(LocalTime closingTime) {
        this.closingTime = closingTime;
    }

    //PRICE
    public float getPrice() {
        return price;
    }
    public void setPrice(float price) {
        this.price = price;
    }

    //SURFACE TYPE
    public SurfaceType getSurfaceType() {
        return surfaceType;
    }
    public void setSurfaceType(SurfaceType surfaceType) {
        this.surfaceType = surfaceType;
    }

    //PITCH TYPE
    public PitchType getPitchType() {
        return pitchType;
    }
    public void setPitchType(PitchType pitchType) {
        this.pitchType = pitchType;
    }

    //AREA TYPE
    public AreaType getAreaType() {
        return areaType;
    }
    public void setAreaType(AreaType areaType) {
        this.areaType = areaType;
    }

    //IMAGE
    public List<Image> getImageList() {
        return imageList;
    }
    public void setImageList(List<Image> imageList) {
        this.imageList = imageList;
    }
}





