import 'dart:io';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:mime/mime.dart';
import 'package:path/path.dart';

final pathAsset = 'assets/agent';

class StaticFile {
  static Future<List<int>> getFileData(String path) async {
    return (await rootBundle.loadString(path, cache: true)).codeUnits;
  }

  static Future writeFile(HttpRequest request) async {
    final path = pathAsset + request.uri.path;
    if (path == pathAsset + '/') {
      await _write(request, path + 'index.html');
    } else {
      await _write(request, path);
    }
  }

  static Future _write(HttpRequest request, String file) async {
    final mime = lookupMimeType(basename(file));
    if (mime != null && !file.contains('.ico')) {
      final list = mime.split('/');
      request.response.headers.contentType = ContentType(list[0], list[1]);
      final bytes = await rootBundle.load(file);
      final result =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      request.response.add(result);
    } else {
      throw 'Arquivo nao encontrado';
    }
    await request.response.close();
  }
}
