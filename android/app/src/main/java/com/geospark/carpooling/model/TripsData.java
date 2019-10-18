package com.geospark.carpooling.model;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

public class TripsData implements Serializable {

    @SerializedName("next_page")
    private Integer nextPage;

    @SerializedName("pages")
    private Integer pages;

    @SerializedName("prev_page")
    private Object prevPage;

    @SerializedName("trips")
    private List<TripsCompleted> trips = null;

    public Integer getNextPage() {
        return nextPage;
    }

    public void setNextPage(Integer nextPage) {
        this.nextPage = nextPage;
    }

    public Integer getPages() {
        return pages;
    }

    public void setPages(Integer pages) {
        this.pages = pages;
    }

    public Object getPrevPage() {
        return prevPage;
    }

    public void setPrevPage(Object prevPage) {
        this.prevPage = prevPage;
    }

    public List<TripsCompleted> getTrips() {
        return trips;
    }

    public void setTrips(List<TripsCompleted> trips) {
        this.trips = trips;
    }
}
