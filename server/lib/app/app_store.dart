import 'dart:async';

import 'package:bibliaehinario/app/core/states/app_state.dart';
import 'package:common/common.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'core/errors/errors.dart';
import 'core/services/web_server/web_server.dart';
import 'core/services/websocket_server/websocket_server.dart';

class AppStore extends NotifierStore<BibliaHinarioError, AppState> {
  late final WebServer _server;
  late final WebSocketServer _serverWebSocket;
  late final StreamSubscription _subServerStatus;
  late final StreamSubscription _subWebSocketServerStatus;
  late final StreamSubscription _subMessageWebSocket;

  AppStore({required WebServer server, required WebSocketServer serverWebSocket}) : super(AppState.empty()) {
    _serverWebSocket = serverWebSocket;
    _server = server;
    _initServer();
    _initWebSocketServer();
  }

  Future _initServer() async {
    _subServerStatus = _server.status.listen(_changeServerStatus);
    _server.start();
  }

  Future _initWebSocketServer() async {
    _subWebSocketServerStatus = _serverWebSocket.status.listen(_changeWebSocketServerStatus);
    _subMessageWebSocket = _serverWebSocket.stream.listen(_handleMessage);
    _serverWebSocket.start();
  }

  void _handleMessage(Message message) {
    if ([MessageType.log, MessageType.slide].contains(message.action)) {
      sendMessage(message);
    } else {
      update(state.copyWith(lastMessage: message));
    }
  }

  void sendMessage(Message message) {
    _serverWebSocket.sendMessage(message);
    update(state.copyWith(lastMessage: message));
  }

  void _changeServerStatus(WebServerStatus status) {
    if (status == WebServerStatus.connected) {
      update(state.copyWith(isWebServerConnected: true));
    } else if (status == WebServerStatus.disconnected) {
      update(state.copyWith(isWebServerConnected: false));
    }
  }

  void _changeWebSocketServerStatus(WebSocketServerStatus status) {
    if (status == WebSocketServerStatus.connected) {
      update(state.copyWith(isWebsocketConnected: true));
    } else if (status == WebSocketServerStatus.disconnected) {
      update(state.copyWith(isWebsocketConnected: false));
    }
  }

  @override
  Future destroy() async {
    await _subWebSocketServerStatus.cancel();
    await _subServerStatus.cancel();
    await _subMessageWebSocket.cancel();
    await _server.dispose();
    await _serverWebSocket.dispose();
    await super.destroy();
  }
}
