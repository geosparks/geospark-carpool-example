package com.geospark.carpooling.client

import retrofit2.Response

object GeoSparkAPIFactory {

    //GeoSpark
    private val GEOSPARK_HOST = "https://api.geospark.co/v1/api/"
    const val TRIP = "trips/"
    const val API_KEY = "Api-Key"
    fun build(): APIInterface {
        return RetrofitClient.geoSparkGetClient(GEOSPARK_HOST).create(APIInterface::class.java)
    }

    fun is201Success(response: Response<*>): Boolean {
        val code = response.code()
        return code == 201
    }

    fun is200Success(response: Response<*>): Boolean {
        val code = response.code()
        return code == 200
    }
}