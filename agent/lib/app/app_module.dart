import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:agent/app/app_widget.dart';
import 'package:agent/app/modules/home/home_module.dart';

import 'modules/slide/slide_module.dart';

class AppModule extends MainModule {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ModuleRoute('/slide', module: SlideModule()),
  ];

  @override
  final Widget bootstrap = AppWidget();
}
