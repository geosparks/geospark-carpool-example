package com.geospark.carpooling.ui

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Geocoder
import android.net.Uri
import android.os.AsyncTask
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import com.geospark.carpooling.BuildConfig
import com.geospark.carpooling.R
import com.geospark.carpooling.callback.UserCallback
import com.geospark.carpooling.client.APIManager
import com.geospark.carpooling.database.*
import com.geospark.carpooling.model.Constant
import com.geospark.carpooling.model.User
import com.geospark.carpooling.util.*
import com.geospark.lib.GeoSpark
import com.geospark.lib.callback.GeoSparkLocationCallback
import com.geospark.lib.model.GeoSparkError
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import com.google.android.gms.maps.model.PolylineOptions
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_find_a_ride.*
import kotlinx.android.synthetic.main.activity_find_a_ride.progress_bar
import org.json.JSONObject
import java.util.*

class FindRideActivity : AppCompatActivity(), OnMapReadyCallback, GoogleMap.OnMapLongClickListener,
    View.OnClickListener {

    private val REQUEST_CODE = 1001
    private var mMapFragment: SupportMapFragment? = null
    private var mMap: GoogleMap? = null
    private var mCustomMarkerView: View? = null
    private var mImgMarker: ImageView? = null
    private val mMarkerPoints = ArrayList<LatLng>()

    public override fun onResume() {
        super.onResume()
        mMapFragment?.onResume()
    }

    public override fun onPause() {
        super.onPause()
        mMapFragment?.onPause()
    }

    override fun onLowMemory() {
        super.onLowMemory()
        mMapFragment?.onLowMemory()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_find_a_ride)
        mCustomMarkerView = (getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(
            R.layout.home_custom_marker,
            null
        )
        mImgMarker = mCustomMarkerView!!.findViewById(R.id.img_marker)
        mMapFragment = supportFragmentManager.findFragmentById(R.id.map) as? SupportMapFragment
        mMapFragment?.getMapAsync(this)
        img_back.setOnClickListener(this)
        txt_start.setOnClickListener(this)
        txt_source.text = multiColorText(getString(R.string.from) + "Tap on map to get address", 6)
        txt_destination.text = multiColorText(getString(R.string.to) + "Tap map to get address", 3)
    }

    override fun onClick(view: View?) {
        when (view!!.id) {
            R.id.txt_start -> {
                requestRide()
            }
            R.id.img_back -> {
                onBackPressed()
            }
        }
    }

    private fun requestRide() {
        if (!hasInternet()) {
            snackBar()
        } else if (mMarkerPoints.size < 2) {
            showToast("Source or Destination coordinates not found")
        } else {
            show()
            val origin = mMarkerPoints[0]
            val destination = mMarkerPoints[1]
            getUserId()?.let {
                try {
                    //Car Pool create trip.
                    APIManager.createRide(it, origin, destination, Constant.REQUESTER, object : UserCallback {
                        override fun successTrue(user: User) {
                            try {
                                hide()
                                //Save requester trip details like Type, source & destination
                                setStarted(true)
                                setTripId("")
                                setTripType(Constant.REQUESTER)
                                setSource(txt_source.text.toString())
                                setDest(txt_destination.text.toString())
                                startActivity(Intent(applicationContext, RideForYouActivity::class.java))
                            } catch (e: Exception) {

                            }
                        }

                        override fun successFalse() {
                            hide()
                        }

                        override fun failure() {
                            hide()
                        }
                    })
                } catch (e: Exception) {

                }
            }
        }
    }

    override fun onMapReady(googleMap: GoogleMap?) {
        mMap = googleMap
        mMap.let {
            it!!.setMapType(GoogleMap.MAP_TYPE_NORMAL)
            it.uiSettings.isMyLocationButtonEnabled = false
            it.uiSettings.isCompassEnabled = false
            it.setOnMapLongClickListener(this)
            requestLocation()
        }
    }

    override fun onMapLongClick(latLng: LatLng) {
        addMarker(latLng)
    }

    private fun requestLocation() {
        if (!GeoSpark.checkLocationPermission(this)) {
            GeoSpark.requestLocationPermission(this)
            return
        }
        GeoSpark.getCurrentLocation(this, 50, object : GeoSparkLocationCallback {
            override fun location(lat: Double, lng: Double, accuracy: Double) {
                try {
                    val latLng = LatLng(lat, lng)
                    mMap!!.addMarker(
                        MarkerOptions().position(latLng).zIndex(1.0f).anchor(0.5f, 0.5f).icon(
                            BitmapDescriptorFactory.fromBitmap(
                                BitmapHelper.getBitmapFromView(
                                    mCustomMarkerView,
                                    mImgMarker,
                                    R.drawable.ic_current_location_marker
                                )
                            )
                        )
                    )
                    mMap!!.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 16f))
                } catch (e: Exception) {
                }
            }

            override fun onFailure(geoSparkError: GeoSparkError) {

            }
        })
    }

    private fun addMarker(latLng: LatLng) {
        try {
            if (mMarkerPoints.size > 1) {
                mMarkerPoints.clear()
                mMap!!.clear()
            }
            mMarkerPoints.add(latLng)
            // Creating MarkerOptions
            val options = MarkerOptions()
            // Setting the position of the marker
            options.position(latLng)
            if (mMarkerPoints.size == 1) {
                val address = getAddress(latLng)
                address.let {
                    txt_source.text = multiColorText(getString(R.string.from) + it, 6)
                }
                options.icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_origin_marker))
                TapToVibrate.vibrate(this)
            } else if (mMarkerPoints.size == 2) {
                val address = getAddress(latLng)
                address.let {
                    txt_destination.text = multiColorText(getString(R.string.to) + it, 3)
                }
                options.icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_destination_marker))
                TapToVibrate.vibrate(this)
            }
            mMap!!.addMarker(options)
            getRoute()
        } catch (e: Exception) {
        }
    }

    private fun getRoute() {
        if (mMarkerPoints.size >= 2) {
            val origin = mMarkerPoints[0]
            val destination = mMarkerPoints[1]
            val url = getDirectionsUrl(origin, destination)
            val downloadTask = DownloadTask()
            downloadTask.execute(url)
        }
    }

    private fun getDirectionsUrl(origin: LatLng, dest: LatLng): String {
        // Origin
        val strOrigin = "origin=" + origin.latitude + "," + origin.longitude
        // Destination
        val strDestination = "destination=" + dest.latitude + "," + dest.longitude
        //Mode & Sensor
        val sensor = "sensor=false"
        val mode = "mode=driving"
        //Key
        val key = "&key=" + resources.getString(R.string.key)
        //Parameters
        val parameters = "$strOrigin&$strDestination&$sensor&$mode$key"
        // Building the url to the web service
        return "https://maps.googleapis.com/maps/api/directions/json?$parameters"
    }

    private fun getAddress(location: LatLng): String? {
        try {
            val geocoder = Geocoder(this, Locale.getDefault())
            val addresses = geocoder.getFromLocation(location.latitude, location.longitude, 1)
            return if (addresses == null || addresses.size == 0) {
                null
            } else {
                addresses[0].getAddressLine(0)
            }
        } catch (e: Exception) {
            return null
        }

    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == GeoSpark.REQUEST_CODE_LOCATION_PERMISSION) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                requestLocation()
            } else if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
                permissionSnackbar()
            }
        }
    }

    private fun show() {
        txt_start.isEnabled = false
        progress_bar.visibility = View.VISIBLE
    }

    private fun hide() {
        txt_start.isEnabled = true
        progress_bar.visibility = View.GONE
    }


    private fun snackBar() {
        Snackbar.make(fab, Constant.NETWORK_ERROR, Snackbar.LENGTH_LONG).show()
    }

    private fun permissionSnackbar() {
        try {
            val snackbar = Snackbar.make(fab, R.string.location_permission_required, Snackbar.LENGTH_INDEFINITE)
                .setAction(R.string.allow, View.OnClickListener {
                    val i = Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.parse("package:" + BuildConfig.APPLICATION_ID)
                    )
                    startActivityForResult(i, REQUEST_CODE)
                })
            snackbar.setActionTextColor(Color.YELLOW)
            snackbar.show()
        } catch (e: Exception) {

        }

    }

    internal inner class DownloadTask : AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg url: String): String {
            var data = ""
            try {
                data = DownloadJSON.url(url[0])
            } catch (e: Exception) {
            }
            return data
        }

        override fun onPostExecute(result: String) {
            super.onPostExecute(result)
            val parserTask = ParserTask()
            parserTask.execute(result)
        }
    }

    internal inner class ParserTask : AsyncTask<String, Int, List<List<HashMap<String, String>>>>() {
        override fun doInBackground(vararg jsonData: String): List<List<HashMap<String, String>>>? {
            val jObject: JSONObject
            var routes: List<List<HashMap<String, String>>>? = null
            try {
                jObject = JSONObject(jsonData[0])
                val parser = DirectionsJSONParser()
                routes = parser.parse(jObject)
            } catch (e: Exception) {

            }
            return routes
        }

        override fun onPostExecute(result: List<List<HashMap<String, String>>>) {
            try {
                var points: ArrayList<LatLng>? = null
                var lineOptions: PolylineOptions? = null
                for (i in result.indices) {
                    points = ArrayList()
                    lineOptions = PolylineOptions()
                    val path = result[i]
                    for (j in path.indices) {
                        val point = path[j]
                        val lat = java.lang.Double.parseDouble(point["lat"].toString())
                        val lng = java.lang.Double.parseDouble(point["lng"].toString())
                        val position = LatLng(lat, lng)
                        points.add(position)
                    }
                    lineOptions.addAll(points)
                    lineOptions.width(9f)
                    lineOptions.color(R.color.colorBlue)
                    lineOptions.geodesic(true)
                }
                mMap!!.addPolyline(lineOptions)
            } catch (e: Exception) {
            }
        }
    }
}
