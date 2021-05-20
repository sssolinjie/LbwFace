/*
 * @Author: your name
 * @Date: 2021-03-09 17:47:41
 * @LastEditTime: 2021-03-25 11:54:47
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /example/Users/imacmini/ParentNode/Flutter/Package/lbwBDFace/lib/lbwBDFace.dart
 */
import 'dart:async';

import 'package:flutter/services.dart';

class LbwBDFace {
  static const MethodChannel _channel = const MethodChannel('lbwBDFace');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //static EventChannel eventChannel = EventChannel('lbwBDFace111');

  ///
  static void _receiveFromeNative(Object para) {
    print("linbingwu" + para.toString());
  }

  static Future<void> initSDK() async {
    //eventChannel.receiveBroadcastStream().listen(_receiveFromeNative);

    // _channel.setMethodCallHandler((call) {
    //   print("linjie" + call.toString());
    // });
    await _channel.invokeMethod('initSDK');
  }

  static Future<void> destory() async {
    await _channel.invokeMethod('destory');
  }

  static Future<String> faceDetect() async {
    String data = await _channel.invokeMethod('faceDetect');
    return data;
  }

  static Future<String> faceLiveness() async {
    String data = await _channel.invokeMethod('faceLiveness');
    return data;
  }
}
