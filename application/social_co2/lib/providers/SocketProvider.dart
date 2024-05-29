import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider with ChangeNotifier {
  // Définition du socket
  late IO.Socket _socket;

  // Création des variables de connexion
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // Constructeur
  SocketProvider() {
    print('initialisation du socket');
    _initSocket();
  }

  void _initSocket() {
    final Map<String, dynamic> options = (kIsWeb)
        ? {}
        : {
            'transports': ['websocket'], // Supporté uniquement sur mobile
          };
    _socket = IO.io('https://api.social-co2.vld-group.com', options);

    _socket.onConnecting((data) => print(data));

    _socket.onError((data) => print(data));

    _socket.on('connect', (_) {
      _isConnected = true;
      print(_isConnected);
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _isConnected = false;
      print(_isConnected);
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
