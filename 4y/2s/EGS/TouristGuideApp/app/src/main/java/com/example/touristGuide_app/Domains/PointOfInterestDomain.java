package com.example.touristGuide_app.Domains;

import java.io.Serializable;
import java.util.Date;
public class PointOfInterestDomain implements Serializable {
    private String id;
    private String name;
    private String locationName;
    private double latitude;
    private double longitude;
    private String street;
    private String postcode;
    private String description;
    private String category;
    private String thumbnail;
    public PointOfInterestDomain(String id, String name, String locationName, double latitude, double longitude, String street, String postcode, String description, String category, String thumbnail) {
        this.id = id;
        this.name = name;
        this.locationName = locationName;
        this.latitude = latitude;
        this.longitude = longitude;
        this.street = street;
        this.postcode = postcode;
        this.description = description;
        this.category = category;
        this.thumbnail = thumbnail;

    }
    public String getId() {return id;}
    public void setId(String id) {this.id = id;}
    public String getName() {return name;}
    public void setName(String name) {this.name = name;}
    public String getLocationName() {return locationName;}
    public void setLocationName(String locationName) {this.locationName = locationName;}
    public double getLatitude() {return latitude;}
    public void setLatitude(double latitude) {this.latitude = latitude;}
    public double getLongitude() {return longitude;}
    public void setLongitude(double longitude) {this.longitude = longitude;}
    public String getStreet() {return street;}
    public void setStreet(String street) {this.street = street;}
    public String getPostcode() {return postcode;}
    public void setPostcode(String postcode) {this.postcode = postcode;}
    public String getDescription() {return description;}
    public void setDescription(String description) {this.description = description;}
    public String getCategory() {return category;}
    public void setCategory(String category) {this.category = category;}
    public String getThumbnail() {return thumbnail;}
    public void setThumbnail(String thumbnail) {this.thumbnail = thumbnail;}
}