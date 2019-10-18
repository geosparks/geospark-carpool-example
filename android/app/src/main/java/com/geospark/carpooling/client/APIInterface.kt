package com.geospark.carpooling.client

import com.geospark.carpooling.model.*
import retrofit2.Call
import retrofit2.http.*

interface APIInterface {

    @Headers("Content-Type: application/json")
    @POST(APIFactory.USER)
    fun createUser(@Body user: UserFields): Call<User>

    @GET(APIFactory.USER)
    fun getUser(@Query("phone") phoneNumber: String): Call<User>

    @Headers("Content-Type: application/json")
    @POST(APIFactory.SERVICE)
    fun ride(@Body user: UserFields): Call<User>

    @GET(APIFactory.SERVICE)
    fun getRideUsers(@Query("service_type") type: String): Call<User>

    @Headers("Content-Type: application/json")
    @POST(APIFactory.TRIP_DATA)
    fun addRide(@Body user: UserFields): Call<User>

    @Headers("Content-Type: application/json")
    @POST(APIFactory.TRIP_METADATA)
    fun addMetadata(@Body user: UserFields): Call<User>

    @Headers("Content-Type: application/json")
    @POST(GeoSparkAPIFactory.TRIP)
    fun createTrip(@Header(GeoSparkAPIFactory.API_KEY) apiKey: String, @Body trip: CreateTrip): Call<CreateTrip>

    @Headers("Content-Type: application/json")
    @GET(GeoSparkAPIFactory.TRIP)
    fun getAllTrip(@Header(GeoSparkAPIFactory.API_KEY) apiKey: String, @Query("user_id") userId: String, @Query("trip_type") tripId: String): Call<Trips>

}

