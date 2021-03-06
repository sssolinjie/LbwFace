/*
 * @Author: your name
 * @Date: 2021-03-09 17:47:42
 * @LastEditTime: 2021-03-16 14:47:36
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /example/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lbwBDFace/lbwBDFace.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    LbwBDFace.initSDK();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await LbwBDFace.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              //Text('Running on: $_platformVersion\n'),
              RaisedButton(
                onPressed: () {
                  LbwBDFace.destory();
                },
                child: Text("销毁sdk"),
              ),
              RaisedButton(
                onPressed: () async {
                  String ss = await LbwBDFace.faceDetect();
                  print(ss);
                },
                child: Text("faceDetect"),
              ),
              RaisedButton(
                onPressed: () async {
                  String ss = await LbwBDFace.faceLiveness();
                  print(ss);
                },
                child: Text("faceLiveness"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
