library common;

import 'dart:convert';

import 'package:collection/collection.dart';

class Message {
  final String value;
  final MessageType action;
  final Map? payload;

  Message({required this.value, required this.action, this.payload});

  factory Message.fromData(dynamic string) {
    try {
      MessageType stringToEnum(String stringAction) {
        for (var _act in MessageType.values) {
          if (_act.toString() == stringAction) return _act;
        }
        return MessageType.log;
      }

      final json = jsonDecode(string);
      return Message(value: json['value'], action: stringToEnum(json['action']), payload: json['payload']);
    } catch (e) {
      return Message(value: e.toString(), action: MessageType.error);
    }
  }

  List<int> toUtf8Value() => jsonEncode({'value': value, 'action': action.toString(), 'payload': payload}).codeUnits;

  String toJsonString() => String.fromCharCodes(toUtf8Value());

  @override
  String toString() => '$action: \"$value\" | payload: $payload';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Message && o.value == value && o.action == action && const MapEquality().equals(o.payload, payload);
  }

  @override
  int get hashCode => value.hashCode ^ action.hashCode ^ payload.hashCode;
}

enum MessageType { notification, slide, log, error }
