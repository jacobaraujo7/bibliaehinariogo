import 'package:common/common.dart';

class AppState {
  final bool isWebsocketConnected;
  final bool isWebServerConnected;
  final Message? lastMessage;

  const AppState({this.isWebsocketConnected = false, this.isWebServerConnected = false, this.lastMessage});

  factory AppState.empty() => AppState();

  AppState copyWith({
    bool? isWebsocketConnected,
    bool? isWebServerConnected,
    Message? lastMessage,
  }) {
    return AppState(
      isWebsocketConnected: isWebsocketConnected ?? this.isWebsocketConnected,
      isWebServerConnected: isWebServerConnected ?? this.isWebServerConnected,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  String toString() => 'AppState(isWebsocketConnected: $isWebsocketConnected, isWebServerConnected: $isWebServerConnected, lastMessage: $lastMessage)';
}
