package com.geospark.carpooling.model

import com.google.gson.annotations.SerializedName

class UserFields {

    @SerializedName("trip_id")
    var tripId: String? = null

    @SerializedName("user_id")
    var userId: String? = null

    @SerializedName("name")
    var name: String? = null

    @SerializedName("phone")
    var phone: String? = null

    @SerializedName("created_at")
    var createdAt: String? = null

    @SerializedName("pool_usr")
    var poolUser: String? = null

    @SerializedName("src_lat")
    var srcLat: Double? = null

    @SerializedName("src_lng")
    var srcLng: Double? = null

    @SerializedName("dest_lat")
    var destLat: Double? = null

    @SerializedName("dest_lng")
    var destLng: Double? = null

    @SerializedName("service_type")
    var serviceType: String? = null
}