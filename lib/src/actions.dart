import 'package:bendium/src/action.dart';

final RegExp _repoRegex = new RegExp(r'https://github\.com/Workiva/([^/?]+)');

String validateAndCoerceToPullRequestUrl(String url) {
  print('validateAndCoerceToPullRequestUrl $url');
  if (url == null) {
    throw new ArgumentError.notNull('url');
  }
  final re = new RegExp(r'(https://github\.com/.*/pull/\d+).*');
  String prUrl;
  try {
    prUrl = re.allMatches(url)?.first?.group(1);
  } catch (exc, trace) {
    print('$exc $trace');
  }
  if (prUrl == null) {
    throw new ArgumentError.value(
        url, 'url', 'Not a PR url; does not match $re');
  }
  return prUrl;
}

String validateAndExtractRepoName(String url) {
  if (url == null) {
    throw new ArgumentError.notNull('url');
  }
  String prUrl;
  try {
    prUrl = _repoRegex.allMatches(url)?.first?.group(1);
  } catch (_) {}
  if (prUrl == null) {
    throw new ArgumentError.value(
        url, 'url', 'Not a repository url; does not match $_repoRegex');
  }
  return prUrl;
}

final Action createJiraTicket = new ActionImpl(
  getMessage: (String url, String value) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    if (value == null || value == '') {
      return 'ticket $validUrl';
    }

    return 'rogue ticket $validUrl $value';
  },
  isActive: Action.isPullRequestUrl,
  parameterName: 'JIRA Project',
  title: 'Create JIRA Ticket',
);

final Action monitorPr = new ActionImpl(
  getMessage: (String url, _) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    return 'monitor pr $validUrl';
  },
  isActive: Action.isPullRequestUrl,
  title: 'Monitor PR',
);

final Action testConsumers = new ActionImpl(
  getMessage: (String url, _) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    return 'test consumers $validUrl';
  },
  isActive: Action.isPullRequestUrl,
  title: 'Test Consumers',
);

final Action mergeMaster = new ActionImpl(
  getMessage: (String url, _) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    return 'update branch $validUrl merge';
  },
  isActive: Action.isPullRequestUrl,
  title: 'Merge Master',
);

final Action updateGolds = new ActionImpl(
  getMessage: (String url, _) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    return 'update golds $validUrl';
  },
  isActive: Action.isPullRequestUrl,
  title: 'Update Gold Files',
);

final Action dartFormat = new ActionImpl(
  getMessage: (String url, _) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    return 'update branch $validUrl format';
  },
  isActive: Action.isPullRequestUrl,
  title: 'Run Dart Format',
);

final Action rerunSmithy = new ActionImpl(
  getMessage: (String url, _) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    return 'rerun smithy for $validUrl';
  },
  isActive: Action.isPullRequestUrl,
  title: 'Re-run Smithy',
);

final Action rerunSkynet = new ActionImpl(
  getMessage: (String url, _) {
    var validUrl = validateAndCoerceToPullRequestUrl(url);
    return 'rerun skynet for $validUrl';
  },
  isActive: Action.isPullRequestUrl,
  title: 'Re-run Skynet',
);

final Action cutRelease = new ActionImpl(
  getMessage: (String url, _) {
    var repoName = validateAndExtractRepoName(url);
    return 'release $repoName';
  },
  isActive: (String url) => url.startsWith(_repoRegex),
  title: 'Cut Release',
);

/// List of actions registered with the extension.
///
/// To add new actions, simply add them to this list.
final Iterable<Action> actions = <Action>[
  createJiraTicket,
  monitorPr,
  testConsumers,
  mergeMaster,
  updateGolds,
  dartFormat,
  rerunSmithy,
  rerunSkynet,
  cutRelease,
];
