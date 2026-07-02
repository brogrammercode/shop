import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';
import 'package:user/services/local_storage.dart';

class SocketService {
  late io.Socket socket;
  final LocalStorage _localStorage;
  final String _baseUrl;

  SocketService(this._baseUrl, this._localStorage);

  void init() async {
    final token = await _localStorage.getToken();
    
    socket = io.io(_baseUrl, io.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .setExtraHeaders({'authorization': 'Bearer $token'})
      .build());

    socket.onConnect((_) {
      debugPrint('Socket connected');
    });

    socket.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });
  }

  void connect() {
    if (!socket.connected) {
      socket.connect();
    }
  }

  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }

  void listenToOrderUpdates(Function(dynamic) callback) {
    socket.on('order:updated', callback);
    socket.on('order:dispatched', callback);
    socket.on('order:delivered', callback);
  }

  void removeOrderListeners() {
    socket.off('order:updated');
    socket.off('order:dispatched');
    socket.off('order:delivered');
  }
}
