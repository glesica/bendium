@JS('chrome.storage.local')
library chromeStorageLocal;

import 'dart:async';

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js;

const hipchatKey = 'hipchat-token';

@JS('get')
external void _get(
  dynamic payload,
  void callback(dynamic object),
);

Future<String> hipchatToken() {
  final payload = js.newObject();
  js.setProperty(payload, hipchatKey, '');

  final completer = Completer<String>();
  _get(payload, allowInterop((object) {
    completer.complete(js.getProperty(object, hipchatKey) as String);
  }));

  return completer.future;
}

Future<String> parameterValue(String commandKey) {
  final payload = js.newObject();
  js.setProperty(payload, commandKey, '');

  final completer = Completer<String>();
  _get(payload, allowInterop((object) {
    completer.complete(js.getProperty(object, commandKey) as String);
  }));

  return completer.future;
}

// TODO: Presumably?
Future<String> slackToken() async {
  return null;
}
