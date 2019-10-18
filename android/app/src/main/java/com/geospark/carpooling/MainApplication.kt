package com.geospark.carpooling

import android.app.Application
import com.geospark.lib.GeoSpark

class MainApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        GeoSpark.initialize(this, "Your-Publish-Key")
    }
}