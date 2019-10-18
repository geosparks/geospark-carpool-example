package com.geospark.carpooling.ui

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.geospark.carpooling.R
import com.geospark.carpooling.database.getName
import com.geospark.carpooling.database.getPhone
import com.geospark.carpooling.database.getUserId
import com.geospark.carpooling.database.setLoggedIn
import com.geospark.carpooling.model.Constant
import com.geospark.carpooling.util.hasInternet
import com.geospark.carpooling.util.showToast
import com.geospark.lib.GeoSpark
import com.geospark.lib.callback.GeoSparkLogoutCallBack
import com.geospark.lib.model.GeoSparkError
import kotlinx.android.synthetic.main.activity_profile.*

class ProfileActivity : AppCompatActivity(), View.OnClickListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)
        txt_logout.setOnClickListener(this)
        img_back.setOnClickListener(this)
        setName()
    }

    override fun onClick(view: View?) {
        when (view!!.id) {
            R.id.img_back -> {
                onBackPressed()
            }
            R.id.txt_logout -> {
                if (!hasInternet()) {
                    showToast(Constant.NETWORK_ERROR)
                } else {
                    logout()
                }
            }
        }
    }

    private fun setName() {
        if (getName()!!.isNotEmpty()) {
            txt_name.text = getName()
        }
        if (getPhone()!!.isNotEmpty()) {
            txt_phone.text = getPhone()
        }
        if (getUserId()!!.isNotEmpty()) {
            txt_userId.text = getUserId()
        }
    }

    private fun logout() {
        show()
        GeoSpark.logout(this, object : GeoSparkLogoutCallBack {
            override fun onSuccess(p0: String?) {
                hide()
                GeoSpark.stopTracking(applicationContext)
                setLoggedIn(false)
                navigate()
            }

            override fun onFailure(p0: GeoSparkError?) {
                hide()
            }
        })
    }

    private fun show() {
        txt_logout.isEnabled = false
        progress_bar.visibility = View.VISIBLE
    }

    private fun hide() {
        txt_logout.isEnabled = true
        progress_bar.visibility = View.GONE
    }


    private fun navigate() {
        val intent = Intent(this, RegisterActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        startActivity(intent)
    }
}
