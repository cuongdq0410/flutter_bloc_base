part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.init() = _Initial;

  const factory LoginState.loginSuccess() = _LoginSuccess;
}

class A {
  final String a;

  A.name(String _a) : a = _a;

  A(this.a);
}
