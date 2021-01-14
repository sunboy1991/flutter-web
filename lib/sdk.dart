/*
 * @Author: sunboylu
 * @Date: 2021-01-11 19:33:44
 * @LastEditors: sunboylu
 * @LastEditTime: 2021-01-14 18:21:54
 * @Description: 
 */

@JS("ZegoExpressEngine")
library ZegoExpressEngine;

import 'dart:html';

import 'package:js/js.dart';

@JS()
class ZegoExpressEngine {
  external ZegoExpressEngine(dynamic appid, String server);
  external loginRoom(String roomid, String token, dynamic options);
  external createStream();
  external startPublishingStream(String roomID, dynamic localStream);
  external startPlayingStream(String streamID, dynamic playOption);
  external stopPublishingStream(String streamID);
  external destroyStream(MediaStream streamID);
  external stopPlayingStream(String streamID);
  external logoutRoom(String roomID);

  external on(String EventName, Object);
}

@JS()
@anonymous
class MapOptions {
  external factory MapOptions({
    String userID,
    String userName,
  });

  external String get userID;
  external String get userName;
}
