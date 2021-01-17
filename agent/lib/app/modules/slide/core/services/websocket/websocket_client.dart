import 'package:common/common.dart';

abstract class WebsocketClient {
  Future<void> start({bool autoReconnect = true});
  Future<void> stop();
  void sendMessage(Message message);
  Future<void> dispose();
  Stream<Message> get stream;
  Stream<WebsocketClientStatus> get status;
}

enum WebsocketClientStatus {
  connected,
  disconnected,
  wait,
  error,
}
