package com.geospark.carpooling.firebase;


import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Build;
import androidx.core.app.NotificationCompat;
import androidx.core.app.TaskStackBuilder;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import com.geospark.carpooling.R;
import com.geospark.carpooling.database.DBSharedPreferenceKt;
import com.geospark.carpooling.model.Constant;
import com.geospark.carpooling.ui.HomeActivity;
import com.geospark.lib.GeoSpark;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Random;

public class MyFireBaseMessagingService extends FirebaseMessagingService {

    public static final String CHANNEL_ID = "carpool_channel";

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        if (token != null) {
            GeoSpark.setDeviceToken(this, token);
        }
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        try {
            DBSharedPreferenceKt.setTripId(this, remoteMessage.getData().get("trip_id"));
            DBSharedPreferenceKt.setNotifyType(this, remoteMessage.getData().get("notification_type"));
            Intent intent = new Intent(Constant.INTENT_TRIP);
            LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
            sendNotification(getApplicationContext(), remoteMessage);
        } catch (Exception e) {
        }
    }

    private void sendNotification(Context context, RemoteMessage remoteMessage) {
        try {
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                CharSequence name = context.getString(R.string.app_name);
                NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, NotificationManager.IMPORTANCE_DEFAULT);
                notificationManager.createNotificationChannel(channel);
            }
            Intent intent = new Intent(context, HomeActivity.class);
            intent.putExtra(GeoSpark.EXTRA, GeoSpark.notificationReceiveHandler(remoteMessage.getData()));
            TaskStackBuilder stackBuilder = TaskStackBuilder.create(context);
            stackBuilder.addNextIntent(intent);
            PendingIntent notificationPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);
            NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID);
            if (remoteMessage.getData().get("message").length() > 50) {
                builder.setSmallIcon(R.drawable.ic_geospark)
                        .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.drawable.ic_geospark))
                        .setContentTitle("Trip")
                        .setStyle(new NotificationCompat.BigTextStyle().bigText(remoteMessage.getData().get("message")))
                        .setContentIntent(notificationPendingIntent);
            } else {
                builder.setSmallIcon(R.drawable.ic_geospark)
                        .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.drawable.ic_geospark))
                        .setContentTitle("Trip")
                        .setContentText(remoteMessage.getData().get("message"))
                        .setContentIntent(notificationPendingIntent);
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                builder.setChannelId(CHANNEL_ID);
            }
            builder.setAutoCancel(true);
            notificationManager.notify(getID(), builder.build());
        } catch (Exception e) {
        }
    }

    public static int getID() {
        return new Random().nextInt(10000);
    }
}
