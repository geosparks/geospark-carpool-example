package com.geospark.carpooling.callback

import com.geospark.carpooling.model.Trip

interface TripCallback {

     fun onSuccess(trip: Trip)

     fun onError(error: Int)
}