package com.fl.fieldservice.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fl.fieldservice.enumTypes.AreaType;
import com.fl.fieldservice.enumTypes.PitchType;
import com.fl.fieldservice.enumTypes.SurfaceType;

import java.time.LocalTime;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class FieldUpdateDto {

    private String name;
    private String description;
    private String city;
    private String address;
    private String phone;
    private String email;
    private String website;

    private Boolean canShower;
    private Boolean hasParking;
    private Boolean hasLighting;
    private Boolean isFree;

    private LocalTime openingTime;
    private LocalTime lunchBrakeStartTime;
    private LocalTime lunchBrakeEndTime;
    private LocalTime closingTime;

    private Float price;

    private SurfaceType surfaceType;
    private PitchType pitchType;
    private AreaType areaType;

    //Getters and Setter


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public Boolean getCanShower() {
        return canShower;
    }

    public void setCanShower(Boolean canShower) {
        this.canShower = canShower;
    }

    public Boolean getHasParking() {
        return hasParking;
    }

    public void setHasParking(Boolean hasParking) {
        this.hasParking = hasParking;
    }

    public Boolean getHasLighting() {
        return hasLighting;
    }

    public void setHasLighting(Boolean hasLighting) {
        this.hasLighting = hasLighting;
    }

    public Boolean getFree() {
        return isFree;
    }

    public void setFree(Boolean free) {
        isFree = free;
    }

    public LocalTime getOpeningTime() {
        return openingTime;
    }

    public void setOpeningT(LocalTime openingTime) {
        this.openingTime = openingTime;
    }

    public LocalTime getLunchBrakeStart() {
        return lunchBrakeStartTime;
    }

    public void setLunchBrakeStart(LocalTime lunchBrakeStartTime) {
        this.lunchBrakeStartTime = lunchBrakeStartTime;
    }

    public LocalTime getLunchBrakeEnd() {
        return lunchBrakeEndTime;
    }

    public void setLunchBrakeEnd(LocalTime lunchBrakeEndTime) {
        this.lunchBrakeEndTime = lunchBrakeEndTime;
    }

    public LocalTime getClosingTime() {
        return closingTime;
    }

    public void setClosingTime(LocalTime closingTime) {
        this.closingTime = closingTime;
    }

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public SurfaceType getSurfaceType() {
        return surfaceType;
    }

    public void setSurfaceType(SurfaceType surfaceType) {
        this.surfaceType = surfaceType;
    }

    public PitchType getPitchType() {
        return pitchType;
    }

    public void setPitchType(PitchType pitchType) {
        this.pitchType = pitchType;
    }

    public AreaType getAreaType() {
        return areaType;
    }

    public void setAreaType(AreaType areaType) {
        this.areaType = areaType;
    }
}
