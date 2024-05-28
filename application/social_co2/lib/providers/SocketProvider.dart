import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  late IO.Socket _socket;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  SocketService() {
    _initSocket();
  }

  void _initSocket() {
    _socket = IO.io('https://api.social-co2.vld-group.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on('connect', (_) {
      _isConnected = true;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _isConnected = false;
      notifyListeners();
    });
  }

  void subscribe(String channel) {
    _socket.on(channel, (data) => null);
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }
}
