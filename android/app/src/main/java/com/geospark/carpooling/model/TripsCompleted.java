package com.geospark.carpooling.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class TripsCompleted implements Serializable {

    @SerializedName("id")
    private String id;

    @SerializedName("origins")
    private List<TripCoordinates> origins = new ArrayList<>();

    @SerializedName("destinations")
    private List<TripCoordinates> destinations = new ArrayList<>();

    @SerializedName("trip_started_at")
    private String tripStart;

    @SerializedName("trip_ended_at")
    private String tripEnd;

    @SerializedName("created_at")
    private String createdAt;

    @SerializedName("updated_at")
    private String updatedAt;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTripStart() {
        return tripStart;
    }

    public void setTripStart(String tripStart) {
        this.tripStart = tripStart;
    }

    public String getTripEnd() {
        return tripEnd;
    }

    public void setTripEnd(String tripEnd) {
        this.tripEnd = tripEnd;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
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
}
