package com.example.touristGuide_app.Domains;

import java.io.Serializable;
import java.util.Date;

public class ListEventsDomain_per_day implements Serializable {
    private String id;
    private String name;
    private String organizer;
    private String category;
    private String contact;
    private Date startDate;
    private Date endDate;
    private String about;
    private double price;
    private String currency;
    private int maxParticipants;
    private int currentParticipants;
    private int trash;
    private String pointOfInterestId;
    private PointOfInterestDomain pointOfInterest;
    private String thumbnailEvent;
    private int userId;
    private int calendarId;

    public ListEventsDomain_per_day(String id, String name, String organizer, String category, String contact, Date startDate,
                                    Date endDate, String about, double price, String currency, int maxParticipants,
                                    int currentParticipants, int trash, String pointOfInterestId, PointOfInterestDomain pointOfInterest, String thumbnailEvent, int userId, int calendarId) {
        this.userId = userId;
        this.calendarId = calendarId;
        this.id = id;
        this.name = name;
        this.organizer = organizer;
        this.category = category;
        this.contact = contact;
        this.startDate = startDate;
        this.endDate = endDate;
        this.about = about;
        this.price = price;
        this.currency = currency;
        this.maxParticipants = maxParticipants;
        this.currentParticipants = currentParticipants;
        this.trash = trash;
        this.pointOfInterestId = pointOfInterestId;
        this.pointOfInterest = pointOfInterest;
        this.thumbnailEvent = thumbnailEvent;
        System.out.println("Passou tudo para o ListEventsDomain?: " +
                "userId: " + userId +
                " calendarId: " + calendarId +
                " id: " + id +
                " name: " + name +
                " organizer: " + organizer +
                " category: " + category +
                " contact: " + contact +
                " startDate: " + startDate +
                " endDate: " + endDate +
                " about: " + about +
                " price: " + price +
                " currency: " + currency +
                " maxParticipants: " + maxParticipants +
                " currentParticipants: " + currentParticipants +
                " favorites: " + trash +
                " pointOfInterestId: " + pointOfInterestId +
                " pointOfInterest: " + pointOfInterest +
                " thumbnailEvent: " + thumbnailEvent);
    }
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOrganizer() {
        return organizer;
    }

    public void setOrganizer(String organizer) {
        this.organizer = organizer;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getAbout() {
        return about;
    }

    public void setAbout(String about) {
        this.about = about;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public int getCurrentParticipants() {
        return currentParticipants;
    }

    public void setCurrentParticipants(int currentParticipants) {
        this.currentParticipants = currentParticipants;
    }

    public int getTrash() {
        return trash;
    }

    public void setTrash(int trash) {
        this.trash = trash;
    }

    public String getPointOfInterestId() {
        return pointOfInterestId;
    }

    public void setPointOfInterestId(String pointOfInterestId) {
        this.pointOfInterestId = pointOfInterestId;
    }

    public PointOfInterestDomain getPointOfInterest() {
        return pointOfInterest;
    }

    public void setPointOfInterest(PointOfInterestDomain pointOfInterest) {
        this.pointOfInterest = pointOfInterest;
    }

    public String getThumbnailEvent() {
        return thumbnailEvent;
    }

    public void setThumbnailEvent(String thumbnailEvent) {
        this.thumbnailEvent = thumbnailEvent;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCalendarId() {
        return calendarId;
    }

    public void setCalendarId(int calendarId) {
        this.calendarId = calendarId;
    }
}