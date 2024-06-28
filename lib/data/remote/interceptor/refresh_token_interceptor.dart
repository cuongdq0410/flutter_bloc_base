import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_skyway_example/data/storage/session_utils.dart';
import 'package:retry/retry.dart';

import '../../../ui/widget/app_navigator.dart';
import '../../../ui/widget/route_define.dart';
import '../../request/refresh_token_request.dart';
import '../api/auth_api.dart';
import '../builder/dio_builder.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  RefreshTokenInterceptor({required this.dio});

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      if (err.response!.statusCode == HttpStatus.unauthorized) {
        unAuthorize(err.response!);
      }
    }
    return handler.next(err);
  }

  /// Api to get new token from refresh token
  ///
  Future<bool> refreshToken() async {
    try {
      final dio = DioBuilder.getInstance(ignoredToken: true);
      final authClient = AuthApi(dio);
      final refreshToken = SessionUtils.getRefreshToken();
      if (refreshToken.isEmpty) return false;
      final request = RefreshTokenRequest(
        refreshToken: refreshToken,
      );
      authClient.refreshToken(request);
      final response = await const RetryOptions(maxAttempts: 3).retry(
        () => authClient.refreshToken(request),
        retryIf: (e) => e is DioException,
      );
      SessionUtils.saveAccessToken(response.accessToken ?? '');
      SessionUtils.saveRefreshToken(response.accessToken ?? '');
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  /// For retrying request with new token
  ///
  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> unAuthorize(Response response) async {
    if (response.statusCode == HttpStatus.unauthorized) {
      SessionUtils.clearSession();
      if (AppNavigator.currentContext == null) return;
      Navigator.pushNamedAndRemoveUntil(
        AppNavigator.currentContext!,
        RouteDefine.loginScreen.name,
        (Route<dynamic> route) => false,
      );
    }
  }
}
