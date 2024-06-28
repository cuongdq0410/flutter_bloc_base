import 'dart:ui';

class AppVersionData {
  final String localVersion;
  final String remoteVersion;
  final bool isForceUpdate;
  final VoidCallback onSkip;

  AppVersionData(
      this.localVersion, this.remoteVersion, this.isForceUpdate, this.onSkip);
}
