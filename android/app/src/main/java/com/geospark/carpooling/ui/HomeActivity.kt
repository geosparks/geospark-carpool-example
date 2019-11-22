package com.geospark.carpooling.ui

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.geospark.carpooling.database.*
import com.geospark.carpooling.model.Constant
import com.geospark.carpooling.util.Crypt
import com.geospark.lib.GeoSpark
import com.geospark.lib.callback.GeoSparkTripCallBack
import com.geospark.lib.model.GeoSparkError
import com.geospark.lib.model.GeoSparkTrip
import kotlinx.android.synthetic.main.activity_home.*


class HomeActivity : AppCompatActivity(), View.OnClickListener {

    override fun onResume() {
        super.onResume()
        register()
        checkTripStatus()
        GeoSpark.startTracking(this)
    }

    override fun onPause() {
        super.onPause()
        unRegister()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(com.geospark.carpooling.R.layout.activity_home)
        setLoggedIn(true)
        setName()
        rl_find.setOnClickListener(this)
        rl_share.setOnClickListener(this)
        rl_history.setOnClickListener(this)
        rl_profile.setOnClickListener(this)
        txt_req_live.setOnClickListener(this)
        txt_req_end.setOnClickListener(this)
        txt_pro_live.setOnClickListener(this)
        txt_pro_end.setOnClickListener(this)
        GeoSpark.startTracking(this)
        clearNotification()
    }

    override fun onClick(view: View?) {
        when (view!!.id) {
            com.geospark.carpooling.R.id.rl_find -> {
                startActivity(Intent(this, FindRideActivity::class.java))
            }
            com.geospark.carpooling.R.id.rl_share -> {
                startActivity(Intent(this, GiveRideActivity::class.java))
            }
            com.geospark.carpooling.R.id.rl_history -> {
                startActivity(Intent(this, TripHistoryActivity::class.java))
            }
            com.geospark.carpooling.R.id.rl_profile -> {
                startActivity(Intent(this, ProfileActivity::class.java))
            }
            com.geospark.carpooling.R.id.txt_req_live -> {
                showTracking()
            }
            com.geospark.carpooling.R.id.txt_pro_live -> {
                showTracking()
            }
            com.geospark.carpooling.R.id.txt_pro_end -> {
                stopTrip()
            }
            com.geospark.carpooling.R.id.txt_req_end -> {
                resetTrip()
                checkTripStatus()
            }
        }
    }

    private fun clearNotification() {
        val nMgr = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nMgr.cancelAll()
    }

    private fun register() {
        val intentFilter = IntentFilter()
        intentFilter.addAction(Constant.INTENT_TRIP)
        LocalBroadcastManager.getInstance(this).registerReceiver(tripReceiver, intentFilter)
    }

    private fun unRegister() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(tripReceiver)
    }

    private fun showTracking() {
        try {
            if (getTripId()!!.isNotEmpty()) {
                val url: String =
                    "https://trips.gs/" + Crypt.encodeString(getTripId() + "|" + "sdfgh")
                startActivity(Intent(this, LiveTrackingActivity::class.java).putExtra("URL", url))
            }
        } catch (e: Exception) {

        }
    }

    private fun setName() {
        if (getName()!!.isNotEmpty()) {
            txt_name.text = "Hey " + getName() + "!"
        }
    }

    private fun checkTripStatus() {
        if (isStarted()!!) {
            item.visibility = View.GONE
            if (getTripType()!!.isNotEmpty() && getTripType().equals(Constant.PROVIDER)) {
                showProvider()
            } else if (getTripType()!!.isNotEmpty() && getTripType().equals(Constant.REQUESTER)) {
                showRequester()
            }
        } else {
            showItem()
        }
    }

    private fun showItem() {
        trip_provider.visibility = View.GONE
        trip_requester.visibility = View.GONE
        item.visibility = View.VISIBLE
    }

    private fun showProvider() {
        trip_requester.visibility = View.GONE
        trip_provider.visibility = View.VISIBLE
        if (getSource()!!.isNotEmpty()) {
            txt_pro_from.text = getSource()!!
        }
        if (getDest()!!.isNotEmpty()) {
            txt_pro_to.text = getDest()!!
        }
        if (getTripId()!!.isEmpty()) {
            txt_req_live.visibility = View.GONE
        } else {
            txt_req_live.visibility = View.VISIBLE
        }
    }

    private fun showRequester() {
        try {
            trip_provider.visibility = View.GONE
            trip_requester.visibility = View.VISIBLE
            if (getSource()!!.isNotEmpty()) {
                txt_req_from.text = getSource()!!
            }
            if (getDest()!!.isNotEmpty()) {
                txt_req_to.text = getDest()!!
            }
            if (getTripId()!!.isEmpty()) {
                txt_req_live.visibility = View.INVISIBLE
            } else {
                txt_req_live.visibility = View.VISIBLE
            }
            if (getNotifyType()!!.isNotEmpty()) {
                if (getNotifyType().equals("destination")) {
                    resetTrip()
                    checkTripStatus()
                }
            }
        } catch (e: Exception) {
        }
    }

    private fun resetTrip() {
        setStarted(false)
        setSource("")
        setDest("")
        setTripType("")
        setNotifyType("")
        setTripId("")
    }

    private fun stopTrip() {
        getTripId().let {
            show()
            GeoSpark.endTrip(this, it, object : GeoSparkTripCallBack {
                override fun onSuccess(p0: GeoSparkTrip?) {
                    hide()
                    resetTrip()
                    checkTripStatus()
                }

                override fun onFailure(p0: GeoSparkError?) {
                    hide()
                }
            })
        }
    }

    private fun show() {
        progress_bar.visibility = View.VISIBLE
    }

    private fun hide() {
        progress_bar.visibility = View.GONE
    }

    private val tripReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            try {
                if (intent.action == Constant.INTENT_TRIP) {
                    checkTripStatus()
                }
            } catch (e: Exception) {
            }
        }
    }
}
