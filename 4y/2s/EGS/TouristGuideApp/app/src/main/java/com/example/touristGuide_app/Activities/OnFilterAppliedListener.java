package com.example.touristGuide_app.Activities;

public interface OnFilterAppliedListener {
    void onFilterApplied(double latitude, double longitude, String locationName, float radius, String category);
}