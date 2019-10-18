package com.geospark.carpooling.client;

import com.geospark.carpooling.model.CreateTrip;
import com.geospark.carpooling.model.UserFields;
import com.google.android.gms.maps.model.LatLng;

public class JSONConverter {

    public static UserFields userBody(String phone, String name, String userId) {
        UserFields json = new UserFields();
        json.setPhone(phone);
        json.setName(name);
        json.setUserId(userId);
        return json;
    }

    public static UserFields requesterBody(String userId, LatLng origin, LatLng destination, String type) {
        UserFields json = new UserFields();
        json.setPoolUser(userId);
        json.setSrcLat(origin.latitude);
        json.setSrcLng(origin.longitude);
        json.setDestLat(destination.latitude);
        json.setDestLng(destination.longitude);
        json.setServiceType(type);
        return json;
    }

    public static UserFields addRequesterBody(String userId, String tripId, LatLng origin, LatLng destination) {
        UserFields json = new UserFields();
        json.setUserId(userId);
        json.setTripId(tripId);
        json.setSrcLat(origin.latitude);
        json.setSrcLng(origin.longitude);
        json.setDestLat(destination.latitude);
        json.setDestLng(destination.longitude);
        return json;
    }

    public static UserFields addMetadataBody(String tripId) {
        UserFields json = new UserFields();
        json.setTripId(tripId);
        return json;
    }

    public static CreateTrip createTripBody(String userId, LatLng originLatLng, LatLng destinationLatLng) {
        Double[][] origin = new Double[][]{{originLatLng.longitude, originLatLng.latitude}};
        Double[][] destination = new Double[][]{{destinationLatLng.longitude, destinationLatLng.latitude}};
        CreateTrip json = new CreateTrip();
        json.setOrigins(origin);
        json.setDestinations(destination);
        json.setUserId(userId);
        return json;
    }
}
