import 'dart:html';

import 'package:agent/app/modules/slide/slide_store.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import 'core/states/slide_state.dart';

class SlidePage extends StatefulWidget {
  final String title;
  const SlidePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  late final SlideStore store;
  @override
  void initState() {
    super.initState();
    store = Modular.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(onPressed: () {
            store.sendMessage(Message(value: 'Echo da internet', action: MessageType.log));
          }),
          ScopedBuilder(
            store: store,
            distinct: (SlideState state) => [state.status, state.urlWebsocket],
            onState: (context, SlideState state) {
              print('status');
              return Text(state.status.toString() + ' url: ${state.urlWebsocket}');
            },
          ),
          ScopedBuilder(
            store: store,
            distinct: (SlideState state) => state.message,
            onState: (context, SlideState state) {
              print('message');
              return Text(state.message.toString());
            },
          ),
          ScopedBuilder(
            store: store,
            filter: (SlideState state) => state.message?.value != 'Echo da internet',
            onState: (context, SlideState state) {
              print('message withless disctinc');
              return Text(state.message.toString());
            },
          ),
        ],
      ),
    );
  }
}
