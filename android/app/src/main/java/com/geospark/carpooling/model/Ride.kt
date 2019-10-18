package com.geospark.carpooling.model

import com.google.gson.annotations.SerializedName

class Ride {

    @SerializedName("fields")
    var requestRide: UserFields? = null

    @SerializedName("user_details")
    var userFields: UserFields? = null

}