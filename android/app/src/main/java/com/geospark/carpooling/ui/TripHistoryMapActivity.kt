package com.geospark.carpooling.ui

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Color
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
import com.geospark.carpooling.model.TripsCompleted
import com.geospark.carpooling.util.DirectionsJSONParser
import com.geospark.carpooling.util.DownloadJSON
import com.geospark.lib.GeoSpark
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
import org.json.JSONObject
import java.util.*

class TripHistoryMapActivity : AppCompatActivity(), OnMapReadyCallback,
    View.OnClickListener {

    private val REQUEST_CODE = 1001
    private var mMapFragment: SupportMapFragment? = null
    private var mMap: GoogleMap? = null
    private var mCustomMarkerView: View? = null
    private var mImgMarker: ImageView? = null

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
        setContentView(R.layout.activity_trip_history_map)
        mCustomMarkerView =
            (getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(
                R.layout.home_custom_marker, null
            )
        mImgMarker = mCustomMarkerView!!.findViewById(R.id.img_marker)
        mMapFragment = supportFragmentManager.findFragmentById(R.id.map) as? SupportMapFragment
        mMapFragment?.getMapAsync(this)
        img_back.setOnClickListener(this)
    }

    override fun onClick(view: View?) {
        when (view!!.id) {
            R.id.img_back -> {
                onBackPressed()
            }
        }
    }

    override fun onMapReady(googleMap: GoogleMap?) {
        mMap = googleMap
        mMap.let {
            it!!.setMapType(GoogleMap.MAP_TYPE_NORMAL)
            it.uiSettings.isMyLocationButtonEnabled = false
            it.uiSettings.isCompassEnabled = false
            requestLocation()
        }
    }

    private fun requestLocation() {
        try {
            if (!GeoSpark.checkLocationPermission(this)) {
                GeoSpark.requestLocationPermission(this)
                return
            }
            mMap!!.clear()
            val tripsCompleted = intent.getSerializableExtra("COORDINATES") as TripsCompleted
            if (tripsCompleted.origins.size != 0) {
                for (i in 0 until tripsCompleted.origins.size) {
                    val origin = tripsCompleted.origins[i]
                    val destination = tripsCompleted.destinations[i]
                    val originLatLng = LatLng(
                        origin.coordinates.coordinates[1],
                        origin.coordinates.coordinates[0]
                    )
                    val destinationLatLng = LatLng(
                        destination.coordinates.coordinates[1],
                        destination.coordinates.coordinates[0]
                    )
                    addMarker(originLatLng, "User origin $i")
                    addDestMarker(destinationLatLng, "User destination $i")
                    getRoute(originLatLng, destinationLatLng)
                }
                mMap!!.moveCamera(
                    CameraUpdateFactory.newLatLngZoom(
                        LatLng(
                            tripsCompleted.origins[0].coordinates.coordinates[1],
                            tripsCompleted.origins[0].coordinates.coordinates[0]
                        ), 14.5f
                    )
                )
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun addMarker(latLng: LatLng, text: String) {
        try {
            // Creating MarkerOptions
            val options = MarkerOptions()
            // Setting the position of the marker
            options.position(latLng)
            options.title(text)
            options.icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_origin_marker))
            mMap!!.addMarker(options)

        } catch (e: Exception) {
        }
    }

    private fun addDestMarker(latLng: LatLng, text: String) {
        try {
            // Creating MarkerOptions
            val options = MarkerOptions()
            // Setting the position of the marker
            options.position(latLng)
            options.title(text)
            options.icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_destination_marker))
            mMap!!.addMarker(options)
        } catch (e: Exception) {
        }
    }

    private fun getRoute(origin: LatLng, destination: LatLng) {
        val url = getDirectionsUrl(origin, destination)
        val downloadTask = DownloadTask()
        downloadTask.execute(url)
    }

    private fun getDirectionsUrl(origin: LatLng, dest: LatLng): String {
        var ai: ApplicationInfo? = null
        try {
            ai = packageManager.getApplicationInfo(packageName, PackageManager.GET_META_DATA)
        } catch (e: PackageManager.NameNotFoundException) {
        }
        val bundle = ai!!.metaData
        val myApiKey = bundle.getString("com.geospark.google.API_KEY")
        return "https://maps.googleapis.com/maps/api/directions/json?" +
                "origin=" + origin.latitude + "," + origin.longitude +
                "&" +
                "destination=" + dest.latitude + "," + dest.longitude +
                "&" +
                "sensor=false" +
                "&" +
                "mode=driving" +
                "&key=" + myApiKey
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == GeoSpark.REQUEST_CODE_LOCATION_PERMISSION) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                requestLocation()
            } else if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
                permissionSnackbar()
            }
        }
    }

    private fun permissionSnackbar() {
        try {
            val snackbar = Snackbar.make(
                fab,
                R.string.location_permission_required,
                Snackbar.LENGTH_INDEFINITE
            )
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

    internal inner class ParserTask :
        AsyncTask<String, Int, List<List<HashMap<String, String>>>>() {
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

