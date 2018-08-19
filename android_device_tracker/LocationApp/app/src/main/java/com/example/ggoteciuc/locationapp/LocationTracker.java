package com.example.ggoteciuc.locationapp;

import android.Manifest;
import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.provider.Settings;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;

import com.github.nkzawa.socketio.client.IO;
import com.github.nkzawa.socketio.client.Socket;

import java.net.URISyntaxException;

public class LocationTracker extends Service {


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private LocationManager locManager;
    private LocationListener locListener;

    private Socket mSocket;

    {
        try {
            mSocket = IO.socket("http://10.0.2.2:8080");
        } catch (URISyntaxException e) {

        }
    }

    @Override
    public void onCreate() {
        //connect to the web socket
        mSocket.connect();

        locManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        locListener = new LocationListener() {
            @Override
            public void onLocationChanged(Location location) {
                double lat = location.getLatitude();
                double lon = location.getLongitude();
                mSocket.emit("location", "{\"lat\": " +
                        Double.toString(lat) +
                        ", \"lon\": " +
                        Double.toString(lon) +
                        "}");
            }

            @Override
            public void onStatusChanged(String provider, int status, Bundle extras) {

            }

            @Override
            public void onProviderEnabled(String provider) {

            }

            @Override
            public void onProviderDisabled(String provider) {
                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            }
        };

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        locManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                5000,
                0,
                locListener
        );
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        if (locManager != null) {
            locManager.removeUpdates(locListener);
        }
    }
}
