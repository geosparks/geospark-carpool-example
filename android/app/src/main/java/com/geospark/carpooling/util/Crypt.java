package com.geospark.carpooling.util;

import android.util.Base64;

import java.io.UnsupportedEncodingException;

public class Crypt {

    public static String encodeString(String plainString) throws UnsupportedEncodingException {
        return Base64.encodeToString(plainString.getBytes("UTF-8"), Base64.DEFAULT);
    }

    public static String decodeString(String encodedString) {
        return String.valueOf(Base64.decode(encodedString, Base64.DEFAULT));

    }

}
