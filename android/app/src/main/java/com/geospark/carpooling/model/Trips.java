package com.geospark.carpooling.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class Trips implements Serializable {

    @SerializedName("data")
    private TripsData data;

    public TripsData getData() {
        return data;
    }

    public void setData(TripsData data) {
        this.data = data;
    }
}
