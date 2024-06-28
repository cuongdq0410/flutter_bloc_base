import 'package:flutter_skyway_example/data/app_error.dart';
import 'package:flutter_skyway_example/data/remote/api/app_api.dart';
import 'package:flutter_skyway_example/data/remote/exception_mapper.dart';
import 'package:flutter_skyway_example/data/request/login_request.dart';
import 'package:flutter_skyway_example/data/response/login_response.dart';
import 'package:flutter_skyway_example/data/storage/session_utils.dart';
import 'package:flutter_skyway_example/domain/repository/auth_repository.dart';
import 'package:flutter_skyway_example/injection/injector.dart';

class AuthRepositoryImpl extends AuthRepository {
  static final AppApi api = injector<AppApi>();

  @override
  Future<LoginResponse?> login(LoginRequest request) async {
    final data = await api.login(request).catchError((error, stackTrace) async {
      throw await injector
          .get<ExceptionMapper>()
          .mapperTo(AppError.from(error as Exception));
    });
    if (data.data?.accessToken != null) {
      SessionUtils.saveAccessToken(data.data!.accessToken!);
    }
    if (data.data?.refreshToken != null) {
      SessionUtils.saveRefreshToken(data.data!.refreshToken!);
    }
    return data.data;
  }
}
