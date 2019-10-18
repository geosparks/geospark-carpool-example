package com.geospark.carpooling.callback

import com.geospark.carpooling.model.CreateTrip

interface CreateTripCallback {

     fun onSuccess(trip: CreateTrip)

     fun onError(error: Int)
}