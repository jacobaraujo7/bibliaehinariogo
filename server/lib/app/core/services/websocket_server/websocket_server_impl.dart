import 'dart:async';
import 'dart:io';

import 'package:common/common.dart';

import 'websocket_server.dart';

class WebSocketServerImpl implements WebSocketServer {
  final int port;

  HttpServer? _server;
  Set<WebSocket> _sockets = {};
  final _controller = StreamController<WebSocketServerStatus>(sync: true);
  final _controllerMessage = StreamController<Message>(sync: true);

  WebSocketServerImpl({this.port = 4041});

  @override
  Stream<Message> get stream => _controllerMessage.stream;

  @override
  Future<void> start() async {
    try {
      _server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        port,
      );
      print('Listening on localhost:${_server?.port}');
      _controller.add(WebSocketServerStatus.connected);

      await for (HttpRequest request in _server!) {
        final _socket = await WebSocketTransformer.upgrade(request);
        _addSocket(_socket);
      }
    } catch (e) {
      _controller.add(WebSocketServerStatus.disconnected);
      print(e);
    }
  }

  Future _addSocket(WebSocket socket) async {
    _sockets.add(socket);
    print('${_sockets.length} start');
    final _sub = socket.map((e) => Message.fromData(e)).listen(_controllerMessage.add);
    await socket.done;
    print('${_sockets.length} close');
    _sockets.remove(socket);
    await _sub.cancel();
  }

  @override
  Future<void> stop() async {
    _controller.add(WebSocketServerStatus.disconnected);
    for (var socket in _sockets) {
      await socket.close();
    }
    _sockets.clear();
    await _server?.close();
    _server = null;
  }

  @override
  Future dispose() async {
    for (var socket in _sockets) {
      await socket.close();
    }
    await _controller.close();
    await _controllerMessage.close();
    await _server?.close();
  }

  @override
  Stream<WebSocketServerStatus> get status => _controller.stream;

  @override
  void sendMessage(Message message) {
    for (var socket in _sockets) {
      socket.addUtf8Text(message.toUtf8Value());
    }
  }
}
