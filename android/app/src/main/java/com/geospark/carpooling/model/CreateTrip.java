package com.geospark.carpooling.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class CreateTrip {

    @SerializedName("data")
    private List<CreateTripData> data = null;

    @SerializedName("trip_id")
    private String tripId;

    @SerializedName("user_id")
    private String userId;

    @SerializedName("origins")
    private Double[][] origins;

    @SerializedName("destinations")
    private Double[][] destinations;

    public List<CreateTripData> getData() {
        return data;
    }

    public void setData(List<CreateTripData> data) {
        this.data = data;
    }

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

    public Double[][] getOrigins() {
        return origins;
    }

    public void setOrigins(Double[][] origins) {
        this.origins = origins;
    }

    public Double[][] getDestinations() {
        return destinations;
    }

    public void setDestinations(Double[][] destinations) {
        this.destinations = destinations;
    }
}
