import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_info_response.freezed.dart';
part 'version_info_response.g.dart';

@freezed
class VersionInfoResponse with _$VersionInfoResponse {
  const factory VersionInfoResponse({
    @JsonKey(name: 'is_force') bool? isForce,
    @JsonKey(name: 'version') String? version,
    @JsonKey(name: 'platform') String? platform,
  }) = _VersionInfoResponse;

  factory VersionInfoResponse.fromJson(Map<String, Object?> json) =>
      _$VersionInfoResponseFromJson(json);
}
