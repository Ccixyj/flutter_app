package com.example.flutterapp;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
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

        final MethodChannel mc = new MethodChannel(getFlutterView(), "app.channel.plugin/share");


        mc.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.contentEquals("getUUID")) {
                    mc.invokeMethod("getWord", null, new MethodChannel.Result() {
                        @Override
                        public void success(Object o) {
                            Log.d("success  ", o.toString());
                        }

                        @Override
                        public void error(String s, String s1, Object o) {

                        }

                        @Override
                        public void notImplemented() {
                        }
                    });

                    ArrayList<String> l = new ArrayList<String>();
                    l.add("ok");
                    l.add("this");
                    l.add("is");
                    l.add("params");
                    mc.invokeMethod("getWordWithParams", l, new MethodChannel.Result() {
                        @Override
                        public void success(Object o) {
                            Toast.makeText(MainActivity.this, o.toString(), Toast.LENGTH_LONG).show();
                        }

                        @Override
                        public void error(String s, String s1, Object o) {

                        }

                        @Override
                        public void notImplemented() {
                        }
                    });


                    result.success("from MainActivity channel: " + System.getProperty("line.separator") + UUID.randomUUID());


                }
            }
        });


    }
}
