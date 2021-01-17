import 'dart:io';

import 'package:bibliaehinario/app/app_store.dart';
import 'package:bibliaehinario/app/core/services/web_server/web_server_impl.dart';
import 'package:bibliaehinario/app/core/services/websocket_server/websocket_server_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Start Server", () async {
    final appStore = AppStore(server: WebServerImpl(), serverWebSocket: WebSocketServerImpl());
    appStore.observer(onState: print);
    await stdin.first;
  });
}
