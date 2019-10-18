package com.geospark.carpooling.ui.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.geospark.carpooling.R
import com.geospark.carpooling.model.Ride
import com.geospark.carpooling.util.multiSizeTextItem

class ProviderAdapter(val context: Context) : RecyclerView.Adapter<ProviderAdapter.ViewHolder>() {

    private val requesterList = ArrayList<Ride>()

    fun addItem(list: ArrayList<Ride>) {
        requesterList.clear()
        requesterList.addAll(list)
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProviderAdapter.ViewHolder {
        val v = LayoutInflater.from(parent.context).inflate(R.layout.item_provider, parent, false)
        return ViewHolder(v)
    }

    override fun onBindViewHolder(viewHolder: ProviderAdapter.ViewHolder, position: Int) {
        val row = requesterList[position]
        try {
            viewHolder.mTxtUserName.setText(context.multiSizeTextItem("Name: " + row.userFields!!.name!!, 6))
            viewHolder.mTxtUserPhone.setText(context.multiSizeTextItem("Phone: " + row.userFields!!.phone!!, 7))
            viewHolder.mTxtUserId.setText(context.multiSizeTextItem("UserId: " + row.userFields!!.userId!!, 8))
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

        init {
            mTxtUserName = view.findViewById(R.id.txt_name)
            mTxtUserPhone = view.findViewById(R.id.txt_phone)
            mTxtUserId = view.findViewById(R.id.txt_userId)
        }
    }
}