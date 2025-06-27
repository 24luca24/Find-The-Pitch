package com.fl.fieldservice.entity;

import com.fl.fieldservice.enumTypes.AreaType;
import com.fl.fieldservice.enumTypes.PitchType;
import com.fl.fieldservice.enumTypes.SurfaceType;
import jakarta.persistence.*;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Field {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;
    private String description;

    @Column(nullable = false)
    private String city;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private String phone;

    @Column(nullable = false)
    private String email;

    private String website;
    private boolean canShower;
    private boolean hasParking;
    private boolean hasLighting;

    @Column(nullable = false)
    private boolean isFree;
    private LocalTime openingTime;
    private LocalTime lunchBrakeStart;
    private LocalTime lunchBrakeEnd;
    private LocalTime closingTime;
    private float price;

    //to select like: SAND / GRASS
    @Enumerated(EnumType.STRING)
    private SurfaceType surfaceType;

    //to select like BASKET / PADEL
    @Enumerated(EnumType.STRING)
    private PitchType pitchType;

    //to select: INDOOR - OUTDOOR
    private AreaType areaType;

    @OneToMany(mappedBy = "field", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Image> images = new ArrayList<>();

    public Field() {}

    //Setter and Getter

    //ID
    private void setId(Long id) {
        this.id = id;
    }
    public Long getId() {
        return id;
    }

    //NAME
    private void setName(String name) {
        this.name = name;
    }
    public String getName() {
        return name;
    }

    //DESCRIPTION
    private void setDescription(String description) {
        this.description = description;
    }
    public String getDescription() {
        return description;
    }

    //CITY
    private void setCity(String city) {
        this.city = city;
    }
    public String getCity() {
        return city;
    }

    //ADDRESS
    private void setAddress(String address) {
        this.address = address;
    }
    public String getAddress() {
        return address;
    }

    //PHONE
    private void setPhone(String phone) {
        this.phone = phone;
    }
    public String getPhone() {
        return phone;
    }

    //EMAIL
    private void setEmail(String email) {
        this.email = email;
    }
    public String getEmail() {
        return email;
    }

    //WEBSITE
    private void setWebsite(String website) {
        this.website = website;
    }
    public String getWebsite() {
        return website;
    }

    //CAN SHOWER
    private void setCanShower(boolean canShower) {
        this.canShower = canShower;
    }
    public boolean getCanShower() {
        return canShower;
    }

    //HAS PARKING
    private void setHasParking(boolean hasParking) {
        this.hasParking = hasParking;
    }
    public boolean getHasParking() {
        return hasParking;
    }

    //HAS LIGHTING
    private void setHasLighting(boolean hasLighting) {
        this.hasLighting = hasLighting;
    }
    public boolean getHasLighting() {
        return hasLighting;
    }

    //IS FREE
    private void setIsFree(boolean isFree) {
        this.isFree = isFree;
    }
    public boolean getIsFree() {
        return isFree;
    }

    //OPENING TIME
    private void setOpeningTime(LocalTime openingTime) {
        this.openingTime = openingTime;
    }
    public LocalTime getOpeningTime() {
        return openingTime;
    }

    //LUNCH BRAKE START
    private void setLunchBrakeStart(LocalTime lunchBrakeStart) {
        this.lunchBrakeStart = lunchBrakeStart;
    }
    public LocalTime getLunchBrakeStart() {
        return lunchBrakeStart;
    }

    //LUNCH BRAKE END
    private void setLunchBrakeEnd(LocalTime lunchBrakeEnd) {
        this.lunchBrakeEnd = lunchBrakeEnd;
    }
    public LocalTime getLunchBrakeEnd() {
        return lunchBrakeEnd;
    }

    //CLOSING TIME
    private void setClosingTime(LocalTime closingTime) {
        this.closingTime = closingTime;
    }
    public LocalTime getClosingTime() {
        return closingTime;
    }

    //PRICE
    private void setPrice(float price) {
        this.price = price;
    }
    public float getPrice() {
        return price;
    }

    //SURFACETYPE
    private void setSurfaceType(SurfaceType surfaceType) {
        this.surfaceType = surfaceType;
    }
    public SurfaceType getSurfaceType() {
        return surfaceType;
    }

    //PITCHTYPE
    private void setPitchType(PitchType pitchType) {
        this.pitchType = pitchType;
    }
    public PitchType getPitchType() {
        return pitchType;
    }

    //AREATYPE
    private void setAreaType(AreaType areaType) {
        this.areaType = areaType;
    }
    public AreaType getAreaType() {
        return areaType;
    }

    //IMAGES
    private void setImages(List<Image> images) {
        this.images = images;
    }
    public List<Image> getImages() {
        return images;
    }
}