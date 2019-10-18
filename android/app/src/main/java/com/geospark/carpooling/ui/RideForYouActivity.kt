package com.geospark.carpooling.ui

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.geospark.carpooling.R
import com.geospark.carpooling.callback.UserCallback
import com.geospark.carpooling.client.APIManager
import com.geospark.carpooling.model.Constant
import com.geospark.carpooling.model.User
import com.geospark.carpooling.ui.adapter.ProviderAdapter
import com.geospark.carpooling.util.EmptyRecyclerView
import com.geospark.carpooling.util.multiSizeText
import kotlinx.android.synthetic.main.activity_ride_for_you.*
import kotlinx.android.synthetic.main.activity_ride_for_you.img_back
import kotlinx.android.synthetic.main.activity_ride_for_you.progress_bar

class RideForYouActivity : AppCompatActivity(), View.OnClickListener {

    private var adapter: ProviderAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_ride_for_you)
        adapter = ProviderAdapter(this)
        val recyclerView: EmptyRecyclerView = findViewById(R.id.recycler_view)
        recyclerView.emptyView = findViewById(R.id.empty_view)
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = adapter
        img_back.setOnClickListener(this)
        img_refresh.setOnClickListener(this)
        setEmptyText()
        getProvider()
    }

    override fun onClick(view: View?) {
        when (view!!.id) {
            R.id.img_back -> {
                onBackPressed()
            }
            R.id.img_refresh -> {
                getProvider()
            }
        }
    }

    private fun setEmptyText() {
        empty_view.text = multiSizeText(resources.getString(R.string.no_provider_request_created), 25)
    }

    private fun show() {
        progress_bar.visibility = View.VISIBLE
    }

    private fun hide() {
        progress_bar.visibility = View.GONE
    }

    private fun getProvider() {
        try {
            show()
            APIManager.getRide(Constant.PROVIDER, object : UserCallback {
                override fun successTrue(user: User) {
                    hide()
                    try {
                        if (user.userData!!.rideProvider!!.isNotEmpty()) {
                            adapter!!.addItem(user.userData!!.rideProvider!!)
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
