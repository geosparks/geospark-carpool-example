package com.geospark.carpooling.util;


import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class DateTime {

    public static String utcToLocal(final String dateString) throws ParseException {
        DateFormat utcFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.getDefault());
        utcFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        Date date = utcFormat.parse(dateString);
        DateFormat currentTFormat = new SimpleDateFormat("dd MMM yyyy HH:mm", Locale.getDefault());
        currentTFormat.setTimeZone(TimeZone.getTimeZone(getTimezone()));
        return currentTFormat.format(date);
    }


    public static String getTimezone() {
        return Calendar.getInstance().getTimeZone().getID();
    }
}
