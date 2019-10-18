package com.geospark.carpooling.ui

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.geospark.carpooling.R
import com.geospark.carpooling.callback.TripsCallback
import com.geospark.carpooling.client.APIManager
import com.geospark.carpooling.database.getUserId
import com.geospark.carpooling.model.Trips
import com.geospark.carpooling.ui.adapter.CompletedTripsAdapter
import com.geospark.carpooling.util.EmptyRecyclerView
import kotlinx.android.synthetic.main.activity_ride_for_you.*

class TripHistoryActivity : AppCompatActivity(), View.OnClickListener {

    private var adapter: CompletedTripsAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_trip_history)
        adapter = CompletedTripsAdapter(this)
        val recyclerView: EmptyRecyclerView = findViewById(R.id.recycler_view)
        recyclerView.emptyView = findViewById(R.id.empty_view)
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = adapter
        img_back.setOnClickListener(this)
        img_refresh.setOnClickListener(this)
        setEmptyText()
        getTripHistory()
    }

    override fun onClick(view: View?) {
        when (view!!.id) {
            R.id.img_back -> {
                onBackPressed()
            }
            R.id.img_refresh -> {
                getTripHistory()
            }
        }
    }

    private fun setEmptyText() {
        empty_view.text = resources.getString(R.string.no_trip_created)
    }

    private fun show() {
        progress_bar.visibility = View.VISIBLE
        empty_view.visibility = View.GONE
    }

    private fun hide() {
        empty_view.visibility = View.VISIBLE
        progress_bar.visibility = View.GONE
    }

    private fun getTripHistory() {
        try {
            show()
            APIManager.getCompletedTrips(getUserId()!!, object : TripsCallback {
                override fun onSuccess(trips: Trips) {
                    try {
                        hide()
                        if (trips.data.trips.size != 0) {
                            adapter!!.addAll(trips.data.trips)
                        }
                    } catch (e: Exception) {

                    }
                }

                override fun onError(error: Int) {
                    hide()
                }
            })
        } catch (e: Exception) {
            hide()
        }
    }
}
