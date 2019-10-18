package com.geospark.carpooling.callback

import com.geospark.carpooling.model.User

interface UserCallback {

    fun successTrue(user: User)

    fun successFalse()

    fun failure()
}