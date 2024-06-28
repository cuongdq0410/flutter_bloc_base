import 'dart:async';

import 'package:flutter_skyway_example/config/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  SocketService() {
    socket = io(
      Constants.shared().socket,
      OptionBuilder() //
          .setTransports(['websocket', 'polling'])
          .disableForceNew()
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(500)
          .setReconnectionDelayMax(3000)
          .build(),
    )
      ..onConnect(_onConnect)
      ..onReconnect(_onReconnect)
      ..onDisconnect(_onDisconnect)
      ..onConnectError((_) => print('Socket Error: $_'))
      ..on('join-room', _onJoinRoom)
      ..on('leave-room', _onLeaveRoom);
  }

  late Socket socket;

  final _connectCtrl = StreamController<bool>.broadcast();
  final _reconnectCtrl = StreamController<bool>.broadcast();

  final _joinRoomCtrl = StreamController<Map<String, dynamic>>.broadcast();
  final _leaveRoomCtrl = StreamController<Map<String, dynamic>>.broadcast();

  Future<void> connect() async {
    socket
      ..auth = {
        'uid': 'user.uid',
        'userId': 'user.id',
      }
      ..disconnect()
      ..connect();
  }

  Stream<bool> get onConnect => _connectCtrl.stream;

  Stream<bool> get onReconnect => _reconnectCtrl.stream;

  Stream<Map<String, dynamic>> get onJoinRoom => _joinRoomCtrl.stream;

  Stream<Map<String, dynamic>> get onLeaveRoom => _leaveRoomCtrl.stream;

  Future<void> disconnect() async => socket.disconnect();

  Future<void> _onConnect(dynamic data) async {
    print('Socket connected!');
    print('Socket pingInterval: ${socket.io.engine?.pingInterval}');
    print('Socket pingTimeout: ${socket.io.engine?.pingTimeout}');
    print('Socket options: ${socket.io.options}');
    _connectCtrl.add(socket.connected);
  }

  Future<void> _onDisconnect(dynamic data) async {
    print('Socket disconnect!');
    _connectCtrl.add(socket.connected);
  }

  Future<void> _onReconnect(dynamic data) async {
    print('Socket onReconnect...');
    _reconnectCtrl.add(true);
  }

  Future<void> _onJoinRoom(dynamic data) async {
    print('Socket event: onJoinRoom!');
    print('$data');
    if (data is Map<String, dynamic>) {
      final user = data['user'];
      if (user is Map<String, dynamic>) data.addAll(user);
      _joinRoomCtrl.add(data);
    }
  }

  Future<void> _onLeaveRoom(dynamic data) async {
    print('Socket event: onLeaveRoom!');
    print('$data');
    if (data is Map<String, dynamic>) {
      _leaveRoomCtrl.add(data);
    }
  }
}
