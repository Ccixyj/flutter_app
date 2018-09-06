package com.example.flutterapp

import android.content.Context
import android.widget.Toast
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel


const val ToastPluginName = "app.channel.plugin/toast"

class ToastPlugin(context: Context ,binaryMessenger: BinaryMessenger ) {



    init {
        val mc = MethodChannel(binaryMessenger, ToastPluginName)
        mc.setMethodCallHandler { methodCall, result ->
            when (methodCall.method) {
                "androidToast" -> {
                    Toast.makeText(context.applicationContext, methodCall.arguments.toString(), Toast.LENGTH_SHORT).show()
                }
            }

        }
    }


}