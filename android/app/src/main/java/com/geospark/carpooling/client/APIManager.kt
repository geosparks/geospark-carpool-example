package com.geospark.carpooling.client

import com.geospark.carpooling.callback.CreateTripCallback
import com.geospark.carpooling.callback.TripsCallback
import com.geospark.carpooling.callback.UserCallback
import com.geospark.carpooling.model.Constant
import com.geospark.carpooling.model.CreateTrip
import com.geospark.carpooling.model.Trips
import com.geospark.carpooling.model.User
import com.google.android.gms.maps.model.LatLng
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

object APIManager {

    fun createUser(phone: String, name: String, userId: String, userCallback: UserCallback) {
        val call = APIFactory.build().createUser(JSONConverter.userBody(phone, name, userId))
        call.enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                try {
                    val user: User? = response.body();
                    if (user!!.status!!) {
                        userCallback.successTrue(user)
                    } else {
                        userCallback.successFalse()
                    }
                } catch (e: Exception) {
                    userCallback.failure()
                }
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                userCallback.failure()
            }
        })
    }

    fun getUser(phone: String, userCallback: UserCallback) {
        val call = APIFactory.build().getUser(phone)
        call.enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                try {
                    val user: User? = response.body();
                    if (user!!.status!!) {
                        userCallback.successTrue(user)
                    } else {
                        userCallback.successFalse()
                    }
                } catch (e: Exception) {
                    userCallback.failure()
                }
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                userCallback.failure()
            }
        })
    }

    fun createRide(userId: String, origin: LatLng, destination: LatLng, type: String, userCallback: UserCallback) {
        val call = APIFactory.build().ride(JSONConverter.requesterBody(userId, origin, destination, type))
        call.enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                try {
                    val user: User? = response.body();
                    if (user!!.status!!) {
                        userCallback.successTrue(user)
                    } else {
                        userCallback.successFalse()
                    }
                } catch (e: Exception) {
                    userCallback.failure()
                }
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                userCallback.failure()
            }
        })
    }

    fun getRide(type: String, userCallback: UserCallback) {
        val call = APIFactory.build().getRideUsers(type)
        call.enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                try {
                    val user: User? = response.body();
                    if (user!!.status!!) {
                        userCallback.successTrue(user)
                    } else {
                        userCallback.successFalse()
                    }
                } catch (e: Exception) {
                    userCallback.failure()
                }
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                userCallback.failure()
            }
        })
    }

    fun addRide(userId: String, tripId: String, origin: LatLng, destination: LatLng, userCallback: UserCallback) {
        val call = APIFactory.build().addRide(JSONConverter.addRequesterBody(userId, tripId, origin, destination))
        call.enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                try {
                    if (GeoSparkAPIFactory.is201Success(response) || GeoSparkAPIFactory.is200Success(response)) {
                        val user: User? = response.body();
                        if (user!!.status!!) {
                            userCallback.successTrue(user)
                        } else {
                            userCallback.successFalse()
                        }
                    } else {
                        userCallback.successFalse()
                    }

                } catch (e: Exception) {
                    userCallback.failure()
                }
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                userCallback.failure()
            }
        })
    }

    fun addMetadata(tripId: String, userCallback: UserCallback) {
        val call = APIFactory.build().addMetadata(JSONConverter.addMetadataBody(tripId))
        call.enqueue(object : Callback<User> {
            override fun onResponse(call: Call<User>, response: Response<User>) {
                try {
                    val user: User? = response.body();
                    if (user!!.status!!) {
                        userCallback.successTrue(user)
                    } else {
                        userCallback.successFalse()
                    }
                } catch (e: Exception) {
                    userCallback.failure()
                }
            }

            override fun onFailure(call: Call<User>, t: Throwable) {
                userCallback.failure()
            }
        })
    }

    fun createTrip(userId: String, origin: LatLng, destination: LatLng, tripCallback: CreateTripCallback) {
        try {
            val call = GeoSparkAPIFactory.build()
                .createTrip(Constant.SERVER_KEY, JSONConverter.createTripBody(userId, origin, destination))
            call.enqueue(object : Callback<CreateTrip> {
                override fun onResponse(call: Call<CreateTrip>, response: Response<CreateTrip>) {
                    try {
                        val trip = response.body()
                        if (GeoSparkAPIFactory.is201Success(response)) {
                            if (trip != null) {
                                tripCallback.onSuccess(trip)
                            }
                        } else {
                            tripCallback.onError(Constant.ERROR_500)
                        }
                    } catch (e: Exception) {
                        tripCallback.onError(Constant.ERROR_500)
                    }
                }

                override fun onFailure(call: Call<CreateTrip>, t: Throwable) {
                    tripCallback.onError(Constant.ERROR_500)
                }
            })
        } catch (e: Exception) {
            tripCallback.onError(Constant.ERROR_500)
        }
    }

    fun getCompletedTrips(userId: String, tripCallback: TripsCallback) {
        try {
            val call = GeoSparkAPIFactory.build().getAllTrip(Constant.SERVER_KEY, userId, "completed")
            call.enqueue(object : Callback<Trips> {
                override fun onResponse(call: Call<Trips>, response: Response<Trips>) {
                    try {
                        val trip = response.body()
                        if (GeoSparkAPIFactory.is201Success(response) || GeoSparkAPIFactory.is200Success(response)) {
                            if (trip != null) {
                                tripCallback.onSuccess(trip)
                            }
                        } else {
                            tripCallback.onError(Constant.ERROR_500)
                        }
                    } catch (e: Exception) {
                        tripCallback.onError(Constant.ERROR_500)
                    }
                }

                override fun onFailure(call: Call<Trips>, t: Throwable) {
                    tripCallback.onError(Constant.ERROR_500)
                }
            })
        } catch (e: Exception) {
            tripCallback.onError(Constant.ERROR_500)
        }
    }
}