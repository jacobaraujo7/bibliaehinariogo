import 'package:agent/app/modules/slide/core/services/websocket/websocket_client.dart';
import 'package:common/common.dart';

class SlideState {
  final String url;
  final String urlWebsocket;
  final WebsocketClientStatus status;
  final Message? message;

  SlideState({
    this.url = '',
    this.urlWebsocket = '',
    this.message,
    this.status = WebsocketClientStatus.disconnected,
  });

  SlideState copyWith({
    String? url,
    String? urlWebsocket,
    Message? message,
    WebsocketClientStatus? status,
  }) {
    return SlideState(
      url: url ?? this.url,
      urlWebsocket: urlWebsocket ?? this.urlWebsocket,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'SlideState(url: $url, urlWebsocket: $urlWebsocket, status: $status, message: $message)';
  }
}
