import 'package:common/common.dart';

abstract class WebSocketServer {
  Future<void> start();
  Future<void> stop();
  void sendMessage(Message message);
  Future dispose();
  Stream<WebSocketServerStatus> get status;
  Stream<Message> get stream;
}

enum WebSocketServerStatus {
  connected,
  disconnected,
}
