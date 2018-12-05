import 'dart:async';
import 'dart:html';

import 'package:bendium/bendium.dart';
import 'package:bendium/src/actions.dart';
import 'package:bendium/src/chrome/chrome.dart' as chrome;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'utils.dart';

Future<Null> updateToken(BenderAdapter adapter, String token) async {
  await chrome.storage.local.set({'hipchat-token': token});
  adapter.token = token;
}

UpdateParameterValueCallback updateParameterValueFactory(Action action) {
  return (String value) {
    action.parameterValue = value;
    chrome.storage.local.set({action.commandKey: value});
  };
}

Future<Null> main() async {
  react_client.setClientConfiguration();

  String url = await currentUrl();

  Map<String, dynamic> data =
      await chrome.storage.local.get({'hipchat-token': ''});

  BenderAdapter adapter = new BenderAdapter();
  adapter.token = data['hipchat-token'] as String;

  for (var action in actions) {
    Map<String, dynamic> actionData =
        await chrome.storage.local.get({action.commandKey: ''});
    action.parameterValue = actionData[action.commandKey] as String;
  }

  final container = querySelector('#container');
  final popup = (Popup()
    ..actions = actions
    ..bender = adapter
    ..currentUrl = url
    ..updateParameterValueCallbackFactory = updateParameterValueFactory
    ..updateTokenCallback = (String token) => updateToken(adapter, token))();
  react_dom.render(popup, container);
}
