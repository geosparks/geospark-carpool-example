package com.geospark.carpooling.database

import android.content.Context
import android.content.SharedPreferences
import com.geospark.carpooling.model.Constant

private object DBSharedPreference {

    private val EMPTY: String? = ""

    private fun getInstance(context: Context): SharedPreferences {
        return context.getSharedPreferences(Constant.SHARED_PREFERENCE, Context.MODE_PRIVATE) as SharedPreferences
    }

    fun setString(context: Context, tag: String, text: String) {
        val editor: SharedPreferences.Editor = getInstance(context).edit()
        editor.putString(tag, text)
        editor.apply()
        editor.commit()
    }

    fun getString(context: Context, tag: String): String? {
        return getInstance(context).getString(tag, EMPTY)
    }

    fun setBoolean(context: Context, tag: String, value: Boolean) {
        val editor: SharedPreferences.Editor = getInstance(context).edit()
        editor.putBoolean(tag, value)
        editor.apply()
        editor.commit()
    }

    fun getBoolean(context: Context, tag: String): Boolean {
        return getInstance(context).getBoolean(tag, false)
    }
}

fun Context.setLoggedIn(value: Boolean) {
    DBSharedPreference.setBoolean(this, Constant.LOGGED_IN, value)
}

fun Context.isLoggedIn(): Boolean {
    return DBSharedPreference.getBoolean(this, Constant.LOGGED_IN)
}

fun Context.setName(text: String) {
    DBSharedPreference.setString(this, Constant.NAME, text)
}

fun Context.getName(): String? {
    return DBSharedPreference.getString(this, Constant.NAME)
}

fun Context.setPhone(text: String) {
    DBSharedPreference.setString(this, Constant.PHONE, text)
}

fun Context.getPhone(): String? {
    return DBSharedPreference.getString(this, Constant.PHONE)
}

fun Context.setUserId(text: String) {
    DBSharedPreference.setString(this, Constant.USER_ID, text)
}

fun Context.getUserId(): String? {
    return DBSharedPreference.getString(this, Constant.USER_ID)
}

fun Context.setTripId(text: String) {
    DBSharedPreference.setString(this, Constant.TRIP_ID, text)
}

fun Context.getTripId(): String? {
    return DBSharedPreference.getString(this, Constant.TRIP_ID)
}

fun Context.setTripType(text: String) {
    DBSharedPreference.setString(this, Constant.TRIP_TYPE, text)
}

fun Context.getTripType(): String? {
    return DBSharedPreference.getString(this, Constant.TRIP_TYPE)
}

fun Context.setStarted(value: Boolean) {
    DBSharedPreference.setBoolean(this, Constant.TRIP_STARTED, value)
}

fun Context.isStarted(): Boolean? {
    return DBSharedPreference.getBoolean(this, Constant.TRIP_STARTED)
}

fun Context.setSource(text: String) {
    DBSharedPreference.setString(this, Constant.SOURCE, text)
}

fun Context.getSource(): String? {
    return DBSharedPreference.getString(this, Constant.SOURCE)
}

fun Context.setDest(text: String) {
    DBSharedPreference.setString(this, Constant.DEST, text)
}

fun Context.getDest(): String? {
    return DBSharedPreference.getString(this, Constant.DEST)
}

fun Context.setNotifyType(text: String) {
    DBSharedPreference.setString(this, Constant.NOTIFICATION_TYPE, text)
}

fun Context.getNotifyType(): String? {
    return DBSharedPreference.getString(this, Constant.NOTIFICATION_TYPE)
}