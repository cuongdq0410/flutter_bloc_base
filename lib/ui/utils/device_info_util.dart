import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future<String?> getDeviceId() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return null;
  }

  static Future<String?> getDeviceName() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    }
    return null;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static int getExtendedVersionNumber(String version) {
    final versionString = version.replaceAll(RegExp(r'\D'), '');
    return int.tryParse(versionString) ?? 100;
  }

  static Future<bool> isAppOutdated(String remoteVersion) async {
    String currentVersion = await getAppVersion();
    int remoteVersionNumber = getExtendedVersionNumber(remoteVersion);
    int currentVersionNumber = getExtendedVersionNumber(currentVersion);
    return remoteVersionNumber > currentVersionNumber;
  }
}
