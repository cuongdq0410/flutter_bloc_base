import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_request.freezed.dart';

part 'refresh_token_request.g.dart';

@freezed
class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @Default('refresh_token') @JsonKey(name: 'grant_type') String? grantType,
    @Default('') @JsonKey(name: 'client_id') String? clientId,
    @Default('') @JsonKey(name: 'client_secret') String? clientSecret,
    @Default('') @JsonKey(name: 'scope') String? scope,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) => _$RefreshTokenRequestFromJson(json);
}
