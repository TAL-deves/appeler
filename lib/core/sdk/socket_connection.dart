import 'dart:async' show StreamSubscription;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as sic;

abstract interface class SocketConnection{

  static const baseUrlSocket = 'https://realtime-db-server.techanalyticaltd.com';
  //static const baseUrlSocket = 'http://139.59.55.201:65000';

  static sic.Socket socket = sic.io(
    baseUrlSocket, <String, dynamic>{
    "transports": ["websocket"],
    'autoConnect' : false,
    //"forceNew": true,
  });

  static StreamSubscription? _subs;

  static void init(){
    socket.onConnect((p) => print(['CONNECTED!!', p]));
    socket.onDisconnect((p) => print(['DISCONNECTED!!', p]));
    socket.onReconnect((p) => print(['RECONNECTED!!', p]));
    socket.onError((p) => print(['ERROR!!', p]));
    socket.onConnecting((p) => print(['CONNECTING!!', p]));
    socket.onConnectError((p) => print(['CONNECT ERROR!!', p]));
    socket.onConnectTimeout((p) => print(['TIMEOUT!!', p]));
    socket.connect();
    _subs = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('connection status is: $result');
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi || result == ConnectivityResult.ethernet || result == ConnectivityResult.vpn || result == ConnectivityResult.other){
        if(socket.disconnected) socket.connect();
      }
      else if(result == ConnectivityResult.none){
        socket.disconnect();
      }
      else {}
    });
    //socket.on('connect_error', (p) => print(['CONNECT ERROR!!', p]));
  }

  static void dispose(){
    _subs?.cancel();
    socket.clearListeners();
    socket.close();
    socket.dispose();
  }
}