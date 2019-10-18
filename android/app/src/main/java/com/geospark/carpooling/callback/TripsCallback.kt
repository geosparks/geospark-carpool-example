package com.geospark.carpooling.callback

import com.geospark.carpooling.model.Trips

interface TripsCallback {

     fun onSuccess(trips: Trips)

     fun onError(error: Int)
}