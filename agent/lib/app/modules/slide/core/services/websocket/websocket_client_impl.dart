import 'dart:async';
import 'dart:html';

import 'package:agent/app/modules/slide/slide_store.dart';
import 'package:common/common.dart';

import 'websocket_client.dart';

class WebsocketClientImpl implements WebsocketClient {
  final _statusController = StreamController<WebsocketClientStatus>(sync: true);
  final _messageController = StreamController<Message>(sync: true);
  final SlideStore slideStore;
  String get _url => slideStore.state.urlWebsocket;

  StreamSubscription? _subOnOpen;
  StreamSubscription? _subOnClose;
  StreamSubscription? _subOnError;
  StreamSubscription? _subOnMessage;
  WebSocket? _socket;

  WebsocketClientImpl(this.slideStore);

  @override
  Stream<WebsocketClientStatus> get status => _statusController.stream;

  @override
  Stream<Message> get stream => _messageController.stream;

  @override
  Future<void> start({bool autoReconnect = true}) async {
    _socket = WebSocket(_url);
    _subOnOpen = _socket?.onOpen.listen((event) => _statusController.add(WebsocketClientStatus.connected));
    _subOnClose = _socket?.onClose.listen((event) async {
      _socket = null;
      await stop();
      if (!autoReconnect) {
        _statusController.add(WebsocketClientStatus.disconnected);
      } else {
        _statusController.add(WebsocketClientStatus.wait);
        await Future.delayed(Duration(seconds: 5));
        start(autoReconnect: autoReconnect);
      }
    });
    _subOnMessage = _socket?.onMessage.map((event) => Message.fromData(event.data)).listen((event) => _messageController.add(event));
    _subOnError = _socket?.onError.listen((event) => _statusController.isClosed || autoReconnect ? null : _statusController.add(WebsocketClientStatus.error));
  }

  void sendMessage(Message message) {
    _socket?.sendString(message.toJsonString());
  }

  @override
  Future<void> stop() async {
    _socket?.close();
    _socket = null;
    await _subOnOpen?.cancel();
    await _subOnClose?.cancel();
    await _subOnMessage?.cancel();
    await _subOnError?.cancel();
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _statusController.close();
    await _messageController.close();
  }
}
