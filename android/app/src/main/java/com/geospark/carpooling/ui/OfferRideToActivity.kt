package com.geospark.carpooling.ui

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.geospark.carpooling.R
import com.geospark.carpooling.callback.UserCallback
import com.geospark.carpooling.client.APIManager
import com.geospark.carpooling.database.getTripId
import com.geospark.carpooling.database.setStarted
import com.geospark.carpooling.model.Constant
import com.geospark.carpooling.model.User
import com.geospark.carpooling.ui.adapter.RequesterAdapter
import com.geospark.carpooling.util.EmptyRecyclerView
import com.geospark.lib.GeoSpark
import com.geospark.lib.callback.GeoSparkTripCallBack
import com.geospark.lib.model.GeoSparkError
import com.geospark.lib.model.GeoSparkTrip
import kotlinx.android.synthetic.main.activity_offer_ride_to.*
import kotlinx.android.synthetic.main.activity_offer_ride_to.progress_bar
import kotlinx.android.synthetic.main.activity_ride_for_you.img_back
import kotlinx.android.synthetic.main.activity_ride_for_you.img_refresh

class OfferRideToActivity : AppCompatActivity(), View.OnClickListener {

    private var adapter: RequesterAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_offer_ride_to)
        adapter = RequesterAdapter(this)
        val recyclerView: EmptyRecyclerView = findViewById(R.id.recycler_view)
        recyclerView.emptyView = findViewById(R.id.empty_view)
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = adapter
        img_back.setOnClickListener(this)
        img_refresh.setOnClickListener(this)
        txt_start.setOnClickListener(this)
        getRequester()
    }

    override fun onClick(view: View?) {
        when (view!!.id) {
            R.id.img_back -> {
                onBackPressed()
            }
            R.id.img_refresh -> {
                getRequester()
            }
            R.id.txt_start -> {
                txt_start.isEnabled = false
                show()
                startTrip()
            }
        }
    }

    private fun show() {
        progress_bar.visibility = View.VISIBLE
    }

    private fun hide() {
        progress_bar.visibility = View.GONE
        txt_start.isEnabled = true
    }

    private fun startTrip() {
        try {
            getTripId().let {
                //Merge trip
                APIManager.addMetadata(it!!, object : UserCallback {
                    override fun successTrue(user: User) {
                        //Start trip
                        GeoSpark.startTrip(applicationContext, it, "", object : GeoSparkTripCallBack {
                            override fun onSuccess(p0: GeoSparkTrip?) {
                                try {
                                    setStarted(true)
                                    hide()
                                    onBackPressed()
                                } catch (e: Exception) {

                                }
                            }

                            override fun onFailure(p0: GeoSparkError?) {
                                hide()
                            }
                        })
                    }

                    override fun successFalse() {
                        hide()
                    }

                    override fun failure() {
                        hide()
                    }
                })
            }
        } catch (e: Exception) {

        }
    }

    private fun getRequester() {
        try {
            show()
            APIManager.getRide(Constant.REQUESTER, object : UserCallback {
                override fun successTrue(user: User) {
                    try {
                        hide()
                        if (user.userData!!.rideRequest!!.isNotEmpty()) {
                            adapter!!.addItem(user.userData!!.rideRequest!!)
                        }
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
            hide()
        }
    }
}
