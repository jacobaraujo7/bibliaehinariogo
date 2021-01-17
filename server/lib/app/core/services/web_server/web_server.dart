abstract class WebServer {
  Future<void> start();
  Future<void> stop();
  Future dispose();
  Stream<WebServerStatus> get status;
}

enum WebServerStatus {
  connected,
  disconnected,
}
