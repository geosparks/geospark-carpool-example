package com.geospark.carpooling.model

import com.google.gson.annotations.SerializedName

class User {

    @SerializedName("status")
    var status: Boolean? = false

    @SerializedName("data")
    var userData: UserData? = null

    @SerializedName("message")
    var message: String? = null
}