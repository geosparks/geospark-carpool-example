package com.geospark.carpooling.ui

import android.content.Intent
import android.os.Bundle
import android.view.KeyEvent
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.geospark.carpooling.R
import com.geospark.carpooling.callback.UserCallback
import com.geospark.carpooling.client.APIManager
import com.geospark.carpooling.database.isLoggedIn
import com.geospark.carpooling.database.setName
import com.geospark.carpooling.database.setPhone
import com.geospark.carpooling.database.setUserId
import com.geospark.carpooling.model.Constant
import com.geospark.carpooling.model.User
import com.geospark.carpooling.util.hasInternet
import com.geospark.carpooling.util.multiSizeText
import com.geospark.carpooling.util.showToast
import com.geospark.lib.GeoSpark
import com.geospark.lib.callback.GeoSparkCallBack
import com.geospark.lib.callback.GeoSparkEventsCallback
import com.geospark.lib.model.GeoSparkError
import com.geospark.lib.model.GeoSparkEvents
import com.geospark.lib.model.GeoSparkUser
import kotlinx.android.synthetic.main.activity_register.*

class RegisterActivity : AppCompatActivity(), View.OnClickListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!isLoggedIn()) {
            setContentView(R.layout.activity_register)
            txt_head.text = multiSizeText("Car Pool \n By GeoSpark", 8)
            txt_get_started.setOnClickListener(this)
            input_number.setOnEditorActionListener(mListener)
            GeoSpark.disableBatteryOptimization(this)
        } else {
            navigate()
        }
    }

    override fun onClick(view: View) {
        when (view.id) {
            R.id.txt_get_started -> {
                getStarted()
            }
        }
    }

    private fun getStarted() {
        var name = input_name.text.toString()
        val phone = input_number.text.toString()
        if (name.isEmpty() || name.length in 21..1) {
            input_name.error = "Enter name "
        } else if (phone.isEmpty() || phone.length < 10) {
            input_number.error = "Enter correct number"
        } else if (!hasInternet()) {
            showToast(Constant.NETWORK_ERROR)
        } else {
            if (!GeoSpark.checkLocationPermission(this)) {
                GeoSpark.requestLocationPermission(this);
            } else if (!GeoSpark.checkLocationServices(this)) {
                GeoSpark.requestLocationServices(this);
            } else {
                show()
                name = name.substring(0, 1).toUpperCase() + name.substring(1)
                getUser(phone, name)
            }
        }
    }

    private fun getUser(phone: String, name: String) {
        APIManager.getUser(phone, object : UserCallback {
            override fun successTrue(user: User) {
                try {
                    setName(user.userData!!.userFields!!.name!!)
                    setPhone(user.userData!!.userFields!!.phone!!)
                    setUserId(user.userData!!.userFields!!.userId!!)
                    geoSparkGetUser(user.userData!!.userFields!!.userId!!)
                } catch (e: Exception) {

                }
            }

            override fun successFalse() {
                geoSparkCreateUser(phone, name)
            }

            override fun failure() {
                hide()
            }
        })
    }

    private fun createUser(phone: String, name: String, userId: String) {
        APIManager.createUser(phone, name, userId, object : UserCallback {
            override fun successTrue(user: User) {
                GeoSpark.toggleEvents(applicationContext, true, true, true, object : GeoSparkEventsCallback {
                    override fun onSuccess(p0: GeoSparkEvents?) {
                        try {
                            hide()
                            setName(user.userData!!.userFields!!.name!!)
                            setPhone(user.userData!!.userFields!!.phone!!)
                            setUserId(user.userData!!.userFields!!.userId!!)
                            navigate()
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

    private fun geoSparkCreateUser(phone: String, name: String) {
        GeoSpark.createUser(this, name, object : GeoSparkCallBack {
            override fun onSuccess(geoSparkUser: GeoSparkUser) {
                createUser(phone, name, geoSparkUser.userId)
            }

            override fun onFailure(goSparkError: GeoSparkError) {
                hide()
            }
        })
    }

    private fun geoSparkGetUser(userId: String) {
        GeoSpark.getUser(this, userId, object : GeoSparkCallBack {
            override fun onSuccess(geoSparkUser: GeoSparkUser) {
                GeoSpark.toggleEvents(applicationContext, true, true, true, object : GeoSparkEventsCallback {
                    override fun onSuccess(p0: GeoSparkEvents?) {
                        hide()
                        navigate()
                    }

                    override fun onFailure(p0: GeoSparkError?) {
                        hide()
                    }
                })
            }

            override fun onFailure(goSparkError: GeoSparkError) {
                hide()
            }
        })
    }

    private fun show() {
        progress_bar.visibility = View.VISIBLE
    }

    private fun hide() {
        progress_bar.visibility = View.GONE
    }

    private fun navigate() {
        GeoSpark.startTracking(this)
        val intent = Intent(this, HomeActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        startActivity(intent)
    }

    private val mListener = TextView.OnEditorActionListener { v, actionId, event ->
        if (event != null && event.keyCode == KeyEvent.KEYCODE_ENTER || actionId == EditorInfo.IME_ACTION_DONE) {
            getStarted()
        }
        false
    }
}
