import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'web_server.dart';

class WebServerImpl extends WebServer {
  final int port;

  HttpServer? _server;
  final _controller = StreamController<WebServerStatus>(sync: true);

  WebServerImpl({this.port = 4042});

  @override
  Future<void> start() async {
    try {
      _server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        port,
      );
      print('Listening on localhost:${_server?.port}');
      _controller.add(WebServerStatus.connected);

      final path = 'assets/agent';

      await for (HttpRequest request in _server!) {
        if (request.uri.path == '/') {
          request.response.headers.contentType = ContentType.html;
          final data = await getFileData('$path/index.html');
          request.response.add(data);
          await request.response.close();
        } else if (request.uri.path == '/main.dart.js') {
          request.response.headers.contentType = ContentType('text', 'javascript');
          await request.response.addStream(Stream.fromFuture(getFileData('$path/main.dart.js')));
          await request.response.close();
        } else if (request.uri.path == '/manifest.json') {
          request.response.headers.contentType = ContentType.json;
          await request.response.addStream(Stream.fromFuture(getFileData('$path/manifest.json')));
          await request.response.close();
        } else if (request.uri.path == '/assets/FontManifest.json') {
          request.response.headers.contentType = ContentType.json;
          await request.response.addStream(Stream.fromFuture(getFileData('$path/assets/FontManifest.json')));
          await request.response.close();
        } else if (request.uri.path == '/assets/fonts/MaterialIcons-Regular.otf') {
          request.response.headers.contentType = ContentType.json;
          await request.response.addStream(Stream.fromFuture(getFileData('$path/assets/fonts/MaterialIcons-Regular.otf')));
          await request.response.close();
        } else {
          print('Tebtatuvas: ${request.uri.path}');
        }
      }
    } catch (e) {
      _controller.add(WebServerStatus.disconnected);
      print(e);
    }
  }

  Future<List<int>> getFileData(String path) async {
    return rootBundle.loadStructuredData(path, (value) async => value.codeUnits);
  }

  @override
  Future<void> stop() async {
    _controller.add(WebServerStatus.disconnected);
    await _server?.close();
    _server = null;
  }

  @override
  Future dispose() async {
    await _controller.close();
    await _server?.close();
  }

  @override
  Stream<WebServerStatus> get status => _controller.stream;
}
