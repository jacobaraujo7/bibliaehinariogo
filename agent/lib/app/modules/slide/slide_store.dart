import 'dart:async';

import 'package:agent/app/modules/slide/core/services/websocket/websocket_client.dart';
import 'package:common/common.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'core/errors/errors.dart';
import 'core/services/websocket/websocket_client_impl.dart';
import 'core/states/slide_state.dart';
import 'package:rxdart/rxdart.dart';

class SlideStore extends NotifierStore<AgentError, SlideState> {
  late final WebsocketClient _websocket = WebsocketClientImpl(this);
  late final StreamSubscription? _subStatusAndMessages;

  SlideStore(String url) : super(SlideState(url: 'http://$url:4042', urlWebsocket: 'ws://$url:4041')) {
    print(url);
    _websocket.start();
    _subStatusAndMessages = Rx.merge<SlideState>([
      _websocket.status.map((status) => state.copyWith(status: status)),
      _websocket.stream.map((message) => state.copyWith(message: message)),
    ]).listen(update);
  }

  void sendMessage(Message message) {
    _websocket.sendMessage(message);
  }

  @override
  Future destroy() async {
    await _subStatusAndMessages?.cancel();
    await _websocket.dispose();
    await super.destroy();
  }
}
