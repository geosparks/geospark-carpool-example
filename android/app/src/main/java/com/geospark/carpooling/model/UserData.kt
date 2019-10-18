package com.geospark.carpooling.model

import com.google.gson.annotations.SerializedName


class UserData {

    @SerializedName("fields")
    var userFields: UserFields? = null

    @SerializedName("provider")
    val rideProvider: ArrayList<Ride>? = null

    @SerializedName("requester")
    val rideRequest: ArrayList<Ride>? = null
}