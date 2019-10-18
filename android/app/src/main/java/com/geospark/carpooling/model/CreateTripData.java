package com.geospark.carpooling.model;

import com.google.gson.annotations.SerializedName;

public class CreateTripData {

    @SerializedName("id")
    private String tripId;

    @SerializedName("user_id")
    private String userId;

    @SerializedName("trip_tracking_url")
    private String tripTrackingUrl;

    public String getTripId() {
        return tripId;
    }

    public void setTripId(String tripId) {
        this.tripId = tripId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTripTrackingUrl() {
        return tripTrackingUrl;
    }

    public void setTripTrackingUrl(String tripTrackingUrl) {
        this.tripTrackingUrl = tripTrackingUrl;
    }

}
