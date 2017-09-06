import 'dart:async';

import 'package:bendium/bendium.dart';
import 'package:chrome/chrome_ext.dart' as chrome;
import 'utils.dart';

Future<Null> main() async {
  // NOTE: Use the "Inspect views: background page" feature of chrome://extensions/ to see logs and errors
  Map<String, dynamic> data =
      await chrome.storage.local.get({'hipchat-token': ''});
  BenderAdapter adapter = new BenderAdapter();
  adapter.token = data['hipchat-token'] as String;

  var actionsMap = <String, Action>{};

  for (var action in actions) {
    actionsMap[action.commandKey] = action;
  }

  // Listen to keyboard shortcuts
  chrome.commands.onCommand.listen((String eventName) async {
    print('event_page.dart received chrome command $eventName');

    // BEWARE: Do not try to get the url outside of this event listener
    // or it will be wrong, likely the chrome://extensions url
    String url = await currentUrl();

    var action = actionsMap[eventName];

    if (action == null) {
      print('Failed to match command name to action: $eventName');
      return;
    }

    // Load parameterValue
    Map<String, dynamic> actionData =
        await chrome.storage.local.get({action.commandKey: ''});
    action.parameterValue = actionData[action.commandKey] as String;

    flashBadge(action.commandKey.substring(0, 1).toUpperCase());
    await adapter.sendMessage(action.getMessage(url, action.parameterValue));
  });
}
