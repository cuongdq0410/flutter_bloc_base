import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(createToJson: false, checked: true)
class LoginResponse {

  @JsonKey(name: 'api_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'user_id')
  final String? userId;

  LoginResponse({this.accessToken, this.refreshToken, this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}