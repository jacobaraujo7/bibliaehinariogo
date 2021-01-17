import 'package:bibliaehinario/app/app_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:bibliaehinario/app/app_widget.dart';
import 'package:bibliaehinario/app/modules/home/home_module.dart';

import 'core/services/web_server/web_server.dart';
import 'core/services/web_server/web_server_impl.dart';
import 'core/services/websocket_server/websocket_server.dart';
import 'core/services/websocket_server/websocket_server_impl.dart';

class AppModule extends MainModule {
  @override
  final List<Bind> binds = [
    Bind.factory<WebServer>((i) => WebServerImpl()),
    Bind.factory<WebSocketServer>((i) => WebSocketServerImpl()),
    Bind.singleton((i) => AppStore(server: i(), serverWebSocket: i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];

  @override
  final Widget bootstrap = AppWidget();
}
