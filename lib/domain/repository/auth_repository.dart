import 'package:flutter_skyway_example/data/request/login_request.dart';
import 'package:flutter_skyway_example/data/response/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse?> login(LoginRequest request);
}
