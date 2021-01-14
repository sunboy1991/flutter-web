import 'dart:html';
import 'dart:js';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/sdk.dart';

void main() {
  runApp(WebcamApp());
  // var zg = init(1739272706, "wss://wssliveroom-test.zego.im/ws");
}

class WebcamApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: WebcamPage(),
      );
}

class WebcamPage extends StatefulWidget {
  @override
  _WebcamPageState createState() => _WebcamPageState();
}

class _WebcamPageState extends State<WebcamPage> {
  // Webcam widget to insert into the tree
  Widget _webcamWidget;
  Widget _webcamWidgetpull;
  // VideoElement
  VideoElement _webcamPushElement;
  VideoElement _webcamPullElement;
  MediaStream localStream;
  MediaStream remoteStream;
  String remoteStreamID;
  String streamID;
  String token =
      "eyJ2ZXIiOjEsImhhc2giOiJlMTA1MTMyMTQwOTU2MjdjZDg3NjI0MWVjMzU1NjAxZSIsIm5vbmNlIjoiMjdlYTExOTdlNWQ2MDBmN2JkNTYwZDA2YzEyNDZkMzgiLCJleHBpcmVkIjoxNjEzMDQ3NTQ0fQ==";
  String roomID = "9999";
  ZegoExpressEngine _zg;
  @override
  void initState() {
    super.initState();
    // Create a video element which will be provided with stream source
    _webcamPushElement = VideoElement();
    _webcamPullElement = VideoElement();
    // Register an webcam
    ui.platformViewRegistry.registerViewFactory(
        'webcamPushElement', (int viewId) => _webcamPushElement);
    ui.platformViewRegistry.registerViewFactory(
        '_webcamPullElement', (int viewId) => _webcamPullElement);
    // Create video widget
    _webcamWidget =
        HtmlElementView(key: UniqueKey(), viewType: 'webcamPushElement');
    _webcamWidgetpull =
        HtmlElementView(key: UniqueKey(), viewType: '_webcamPullElement');
    // 回调函数
    void roomStreamUpdate(String roomID, String updateType, List streamList,
        String extendedData) {
      if (updateType == "ADD") {
        for (var i = 0; i < streamList.length; i++) {
          _zg.startPlayingStream(streamList[i].streamID, {}).then((value) {
            remoteStreamID = streamList[i].streamID;
            _webcamPullElement.srcObject = value;
            _webcamPullElement.muted = true;
            remoteStream = value;
            _webcamPullElement.play();
          }, onError: (dynamic e) {
            print(e);
          });
        }
      }
    }

    // 初始化sdk
    _zg = ZegoExpressEngine(1739272706, 'wss://wssliveroom-test.zego.im/ws');
    //注册回调
    _zg.on("roomStreamUpdate", allowInterop(roomStreamUpdate));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Container(
                padding: new EdgeInsets.all(200.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '推流:',
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                                width: 500, height: 300, child: _webcamWidget),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '拉流:',
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                                width: 500,
                                height: 300,
                                child: _webcamWidgetpull),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.blue,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("登录房间"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            MapOptions _mapOptions = MapOptions(
                              userID: "1610455534676",
                              userName: "u1610455534676",
                            );
                            var promise =
                                _zg.loginRoom(roomID, token, _mapOptions);
                            promise.then((value) {
                              print('初始化成功：$value');
                            }, onError: (dynamic e) {
                              print('初始化错误：$e');
                            });
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("开始推流"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            //创建流
                            _zg.createStream().then((value) {
                              print('创建流成功：$value');
                              _webcamPushElement.srcObject = value;
                              _webcamPushElement.srcObject.active
                                  ? _webcamPushElement.play()
                                  : _webcamPushElement.pause();
                              _webcamPushElement.muted = true;
                              localStream = value;
                              streamID = "testId";
                              _zg.startPublishingStream(streamID, value);
                            }, onError: (dynamic e) {
                              print('初始化错误：$e');
                            });
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("停止推流"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            _webcamPushElement.pause();
                            _webcamPushElement.srcObject = null;
                            _zg.stopPublishingStream(streamID);
                            _zg.destroyStream(localStream);
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("停止拉流"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            _webcamPullElement.pause();
                            _webcamPullElement.srcObject = null;
                            _zg.stopPlayingStream(streamID);
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("退出房间"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            _webcamPushElement.pause();
                            _webcamPushElement.srcObject = null;
                            _webcamPullElement.pause();
                            _webcamPullElement.srcObject = null;
                            _zg.logoutRoom(roomID);
                          },
                        ),
                      ],
                    ),
                  ],
                ))),
      );
}
