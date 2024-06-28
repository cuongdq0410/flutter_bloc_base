import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_data_model.dart';

part 'app_error_data_model.freezed.dart';
part 'app_error_data_model.g.dart';

@freezed
class AppErrorDataModel with _$AppErrorDataModel {
  const factory AppErrorDataModel({
    int? statusCode,
    List<ErrorsData>? errors,
    String? message,
  }) = _AppErrorDataModel;

  factory AppErrorDataModel.fromJson(Map<String, dynamic> json) =>
      _$AppErrorDataModelFromJson(json);
}

@freezed
class ErrorsData with _$ErrorsData {
  const factory ErrorsData({
    @JsonKey(name: 'value') String? value,
    @JsonKey(name: 'msg') String? msg,
    @JsonKey(name: 'param') String? param,
    @JsonKey(name: 'location') String? location,
  }) = _ErrorsData;

  factory ErrorsData.fromJson(Map<String, Object?> json) =>
      _$ErrorsDataFromJson(json);
}

extension AppErrorDataModelExt on AppErrorDataModel {
  ErrorDataModel toErrorDataModel() => ErrorDataModel(
        errorCode: statusCode,
        message: message,
        errors: errors
                ?.map(
                  (e) => ErrorModel(
                    msg: e.msg ?? '',
                    location: e.location ?? '',
                    param: e.param ?? '',
                    value: e.value ?? '',
                  ),
                )
                .toList() ??
            [],
      );
}
