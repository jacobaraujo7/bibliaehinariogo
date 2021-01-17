import 'dart:async';
import 'dart:io';
import 'static_files.dart';
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

      await for (HttpRequest request in _server!) {
        try {
          await StaticFile.writeFile(request);
        } catch (e) {
          request.response.headers.contentType = ContentType.html;
          request.response.statusCode = 404;
          request.response.add('Arquivo nao encontrado'.codeUnits);
          print(e);
        }
      }
    } catch (e) {
      _controller.add(WebServerStatus.disconnected);
      print(e);
    }
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
