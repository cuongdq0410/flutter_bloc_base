import 'package:flutter_skyway_example/data/request/login_request.dart';
import 'package:flutter_skyway_example/data/response/login_response.dart';
import 'package:flutter_skyway_example/domain/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _repository;

  AuthUseCase(this._repository);

  Future<LoginResponse?> login(LoginRequest request) {
    return _repository.login(request);
  }
}
