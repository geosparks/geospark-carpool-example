package com.geospark.carpooling.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class Coordinates implements Serializable {

    @SerializedName("type")
    private String type;

    @SerializedName("coordinates")
    private Double[] coordinates;


    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Double[] getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(Double[] coordinates) {
        this.coordinates = coordinates;
    }
}
