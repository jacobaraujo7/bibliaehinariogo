import 'package:agent/app/modules/slide/core/services/websocket/websocket_client_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'slide_page.dart';
import 'slide_store.dart';

class SlideModule extends ChildModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SlideStore(i.args?.params['url'] ?? 'localhost')),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/:url', child: (_, args) => SlidePage()),
  ];
}
