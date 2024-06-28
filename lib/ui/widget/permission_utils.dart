import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/dialog_utils.dart';
import 'app_navigator.dart';
import 'notification_dialog.dart';

class PermissionUtils {
  static Future<bool> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) return true;
    status = await Permission.camera.request();
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      await DialogUtils.showCustomDialog(
        NotificationDialog(
          title: 'Notification',
          descriptionText: 'You need to allow access to the camera',
          buttonText: 'Setting',
          onClickButton: () {
            Navigator.pop(AppNavigator.currentContext!);
            openAppSettings();
          },
        ),
      );
    }
    return status.isGranted;
  }

  static Future<bool> requestPhotoPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) return true;
    if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else {
      bool isAboveSdk33 = await isAboveAndroidSdk33();
      status = isAboveSdk33
          ? await Permission.photos.request()
          : await Permission.storage.request();
    }
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      await DialogUtils.showCustomDialog(
        NotificationDialog(
          title: 'Notification',
          descriptionText: 'You must grant permission to access your photo library.',
          buttonText: 'Setting',
          onClickButton: () {
            Navigator.pop(AppNavigator.currentContext!);
            openAppSettings();
          },
        ),
      );
    }
    return status.isGranted || status.isLimited;
  }

  static Future<bool> isAboveAndroidSdk33() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  static Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) return true;
    status = await Permission.location.request();
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      await DialogUtils.showCustomDialog(
        NotificationDialog(
          title: '通知',
          descriptionText: '自分の位置情報へのアクセスを許可する必要があります。',
          buttonText: '設定',
          onClickButton: () {
            Navigator.pop(AppNavigator.currentContext!);
            openAppSettings();
          },
        ),
      );
    }
    return status.isGranted;
  }
}
