package com.geospark.carpooling.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class TripData {

    @SerializedName("id")
    private String tripId;

    @SerializedName("origins")
    private List<TripCoordinates> origins = null;

    @SerializedName("destinations")
    private List<TripCoordinates> destinations = null;

    @SerializedName("user_id")
    private String userId;


    public String getTripId() {
        return tripId;
    }

    public void setTripId(String tripId) {
        this.tripId = tripId;
    }

    public List<TripCoordinates> getOrigins() {
        return origins;
    }

    public void setOrigins(List<TripCoordinates> origins) {
        this.origins = origins;
    }

    public List<TripCoordinates> getDestinations() {
        return destinations;
    }

    public void setDestinations(List<TripCoordinates> destinations) {
        this.destinations = destinations;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}
