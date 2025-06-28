package com.fl.authenticationservice.entity;

import jakarta.persistence.*;

@Entity
public class City {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String cap;

    @Column(nullable = false)
    private String provinceAbbreviation;

    @Column(nullable = false)
    private String province;

    @Column(nullable = false)
    private String region;

    @Column(nullable = false)
    private double latitude;

    @Column(nullable = false)
    private double longitude;

    //Constructors
    public City() {

    }

    public City(String name, String cap, String provinceAbbreviation, String province, String region, double latitude, double longitude) {
        this.name = name;
        this.cap = cap;
        this.provinceAbbreviation = provinceAbbreviation;
        this.province = province;
        this.region = region;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    //Getters and Setters

    //ID
    public void setId(Long id) {
        this.id = id;
    }
    public Long getId() {
        return id;
    }

    //NAME
    public void setName(String name) {
        this.name = name;
    }
    public String getName() {
        return name;
    }

    //CAP
    public void setCap(String cap) {
        this.cap = cap;
    }
    public String getCap() {
        return cap;
    }

    //PROVINCE ABBREVIATION
    public void setProvinceAbbreviation(String provinceAbbreviation) {
        this.provinceAbbreviation = provinceAbbreviation;
    }
    public String getProvinceAbbreviation() {
        return provinceAbbreviation;
    }

    //PROVINCE
    public void setProvince(String province) {
        this.province = province;
    }
    public String getProvince() {
        return province;
    }

    //REGION
    public void setRegion(String region) {
        this.region = region;
    }
    public String getRegion() {
        return region;
    }

    //LATITUDE
    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }
    public double getLatitude() {
        return latitude;
    }

    //LONGITUDE
    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }
    public double getLongitude() {
        return longitude;
    }
}
