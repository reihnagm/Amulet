import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:amulet/providers/network.dart';

class SocketServices {
  static final shared = SocketServices();
  late io.Socket socket;

  void connect(BuildContext context) {
    // http://192.168.113.73:3000
    // http://192.168.43.17:3000
    // http://cxid.xyz:3000
    socket = io.io('http://cxid.xyz:3000', <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });    
    socket.connect();
    socket.on("connect", (_) {
      debugPrint("=== SOCKET IS CONNECTED ===");
      context.read<NetworkProvider>().turnOnSocket();
      // socket.on("message", (data) {
        // final r = data as dynamic;
        // final d = r as Map<String, dynamic>;
        // context.read<VideoProvider>().appendSos(d);
      // });
    });
    socket.on("disconnect", (_) {
      debugPrint("=== SOCKET IS DISCONNECTED  ===");
      context.read<NetworkProvider>().turnOffSocket();
    });
    socket.onConnect((_) {
      context.read<NetworkProvider>().turnOnSocket();
    });
    socket.onDisconnect((_) {
      context.read<NetworkProvider>().turnOffSocket();
      Timer.periodic(const Duration(seconds: 1), (Timer t) => socket.connect());
    });
    socket.onConnectTimeout((_) {
      context.read<NetworkProvider>().turnOffSocket();
      Timer.periodic(const Duration(seconds: 1), (Timer t) => socket.connect());
    });
    socket.onError((_) {
      context.read<NetworkProvider>().turnOffSocket();
      Timer.periodic(const Duration(seconds: 1), (Timer t) => socket.connect());
    });
    socket.onReconnectError((_) {
      context.read<NetworkProvider>().turnOffSocket();
      Timer.periodic(const Duration(seconds: 1), (Timer t) => socket.connect());
    });
    socket.onReconnectFailed((_) {
      context.read<NetworkProvider>().turnOffSocket();
      Timer.periodic(const Duration(seconds: 1), (Timer t) => socket.connect());
    });
    socket.onConnectError((_) {
      context.read<NetworkProvider>().turnOffSocket();
      Timer.periodic(const Duration(seconds: 1), (Timer t) => socket.connect());
    });
  }
  
  // Future<void> sendMsg({
  //   required String id, 
  //   required String content, 
  //   required String mediaUrl,
  //   required String mediaUrlPhone,
  //   required String category,
  //   required String lat, 
  //   required String lng,
  //   required String address,
  //   required String status,
  //   required String duration,
  //   required String fullname,
  //   required String thumbnail,
  //   required String userId,
  //   required String signId
  // }) async {
  //   socket.emit("message", jsonEncode({
  //     "id": id,
  //     "content": content,
  //     "mediaUrl": mediaUrl,
  //     "mediaUrlPhone": mediaUrlPhone,
  //     "category": category,
  //     "lat": lat,
  //     "lng": lng,
  //     "address": address,
  //     "status": status,
  //     "duration": duration,
  //     "fullname": fullname,
  //     "thumbnail": thumbnail,
  //     "user_id": userId
  //   }));
  //   socket.emit("broadcast", jsonEncode({
  //     "uid": id,
  //     "address": address,
  //     "category": category,
  //     "content": content,
  //     "sign_id": signId,
  //     "media_url_phone": mediaUrlPhone, 
  //     "thumbnail": thumbnail,
  //     "sender_name": fullname,
  //     "sender_fcm": await FirebaseMessaging.instance.getToken(), 
  //     "lat": lat,
  //     "lng": lng
  //   }));
  // }

  void dispose() {
    socket.clearListeners();
  }
}