import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../storage/session_utils.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  final String accept = 'Accept';
  final String userAgentKey = 'User-Agent';
  final String authHeaderKey = 'Authorization';
  final String bearer = 'Bearer';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[accept] = 'application/json';
    final userAgentValue = await userAgentClientHintsHeader();

    final token = SessionUtils.getAccessToken();

    if (token.isNotEmpty) options.headers[authHeaderKey] = '$bearer $token';
    options.headers[userAgentKey] = userAgentValue;

    handler.next(options);
  }

  Future<String> userAgentClientHintsHeader() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${Platform.operatingSystem} - ${packageInfo.buildNumber}';
    } on Exception catch (_) {
      return 'The Platform not support get info';
    }
  }
}
