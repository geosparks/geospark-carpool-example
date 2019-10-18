package com.geospark.carpooling.client

object APIFactory {

    private const val HOST = "http://redbus.geospark.xyz/"
    const val USER = "user/"
    const val SERVICE = "service/"
    const val TRIP_METADATA = "trip-metadata/"
    const val TRIP_DATA = "trip-data/"

    fun build(): APIInterface {
        return RetrofitClient.getClient(HOST).create(APIInterface::class.java)
    }
}