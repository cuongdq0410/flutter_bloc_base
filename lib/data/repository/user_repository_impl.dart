import 'dart:io';

import 'package:flutter_skyway_example/data/remote/api/app_api.dart';
import 'package:flutter_skyway_example/data/response/version_info_response.dart';
import 'package:flutter_skyway_example/domain/repository/user_repository.dart';
import 'package:flutter_skyway_example/injection/injector.dart';

import '../app_error.dart';
import '../remote/exception_mapper.dart';

class UserRepositoryImpl extends UserRepository {
  static final AppApi api = injector<AppApi>();
  final ExceptionMapper _exceptionMapper;

  UserRepositoryImpl(this._exceptionMapper);

  @override
  Future<VersionInfoResponse> getAppVersion() {
    return api
        .getAppVersion(Platform.isIOS ? 'ios' : 'android')
        .catchError((error, stackTrace) async {
      throw await _exceptionMapper.mapperTo(AppError.from(error as Exception));
    });
  }
}
