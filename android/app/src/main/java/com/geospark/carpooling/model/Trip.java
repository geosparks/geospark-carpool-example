package com.geospark.carpooling.model;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Trip {

    @SerializedName("trip_id")
    private String tripId;

    @SerializedName("origins")
    private Double[][] origins;

    @SerializedName("destinations")
    private Double[][] destinations;

    @SerializedName("data")
    private List<TripData> data = null;

    public String getTripId() {
        return tripId;
    }

    public void setTripId(String tripId) {
        this.tripId = tripId;
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

    public List<TripData> getData() {
        return data;
    }

    public void setData(List<TripData> data) {
        this.data = data;
    }
}
