package com.geospark.carpooling.ui.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.geospark.carpooling.R
import com.geospark.carpooling.callback.UserCallback
import com.geospark.carpooling.client.APIManager
import com.geospark.carpooling.database.getTripId
import com.geospark.carpooling.model.Ride
import com.geospark.carpooling.model.User
import com.geospark.carpooling.util.multiSizeTextItem
import com.geospark.carpooling.util.showToast
import com.google.android.gms.maps.model.LatLng

class RequesterAdapter(val context: Context) : RecyclerView.Adapter<RequesterAdapter.ViewHolder>() {

    private val requesterList = ArrayList<Ride>()

    fun addItem(list: ArrayList<Ride>) {
        requesterList.clear()
        requesterList.addAll(list)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RequesterAdapter.ViewHolder {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.item_requester, parent, false)
        return ViewHolder(v)
    }

    override fun onBindViewHolder(viewHolder: RequesterAdapter.ViewHolder, position: Int) {
        val row = requesterList[position]
        try {
            viewHolder.mTxtUserName.text = context.multiSizeTextItem("Name: " + row.userFields!!.name!!, 6)
            viewHolder.mTxtUserPhone.text = context.multiSizeTextItem("Phone: " + row.userFields!!.phone!!, 7)
            viewHolder.mTxtUserId.text = context.multiSizeTextItem("UserId: " + row.userFields!!.userId!!, 8)
            viewHolder.mItem.setOnClickListener {
                viewHolder.mItem.visibility = View.GONE
                viewHolder.mProgressBar.visibility = View.VISIBLE
                try {
                    APIManager.addRide(
                        row.userFields!!.userId!!, context.getTripId()!!,
                        LatLng(row.requestRide!!.srcLat!!, row.requestRide!!.srcLng!!),
                        LatLng(row.requestRide!!.destLat!!, row.requestRide!!.destLng!!), object : UserCallback {
                            override fun successTrue(user: User) {
                                viewHolder.mItem.visibility = View.VISIBLE
                                viewHolder.mProgressBar.visibility = View.GONE
                                context.showToast("Request accepted")
                            }

                            override fun successFalse() {
                                viewHolder.mItem.visibility = View.VISIBLE
                                viewHolder.mProgressBar.visibility = View.GONE
                                context.showToast("Already request accepted")
                            }

                            override fun failure() {
                                viewHolder.mItem.visibility = View.VISIBLE
                                viewHolder.mProgressBar.visibility = View.GONE
                                context.showToast("Retry again")
                            }
                        })
                } catch (e: Exception) {
                    viewHolder.mItem.visibility = View.VISIBLE
                    viewHolder.mProgressBar.visibility = View.GONE
                }
            }
        } catch (e: Exception) {
        }
    }

    override fun getItemCount(): Int {
        return requesterList.size
    }

    inner class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val mTxtUserName: TextView
        val mTxtUserPhone: TextView
        val mTxtUserId: TextView
        val mItem: LinearLayout
        val mProgressBar: ProgressBar

        init {
            mTxtUserName = view.findViewById(R.id.txt_name)
            mTxtUserPhone = view.findViewById(R.id.txt_phone)
            mTxtUserId = view.findViewById(R.id.txt_userId)
            mItem = view.findViewById(R.id.item)
            mProgressBar = view.findViewById(R.id.progressBar)

        }
    }
}