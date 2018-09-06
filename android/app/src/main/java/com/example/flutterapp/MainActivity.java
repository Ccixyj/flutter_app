package com.example.flutterapp;

import android.graphics.Path;
import android.os.Bundle;
import android.util.Log;

import java.io.File;
import java.security.MessageDigest;
import java.util.UUID;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), "app.channel.plugin/share")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if (methodCall.method.contentEquals("getUUID")) {
                            result.success("from MainActivity channel: "  +System.getProperty("line.separator") + UUID.randomUUID());
                        }
                    }
                });


    }
}
