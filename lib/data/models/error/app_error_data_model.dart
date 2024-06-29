import 'package:freezed_annotation/freezed_annotation.dart';

import 'error_item_data_model.dart';

part 'app_error_data_model.freezed.dart';

part 'app_error_data_model.g.dart';

@freezed
class AppErrorDataModel with _$AppErrorDataModel {
  const factory AppErrorDataModel({
    String? status,
    String? message,
    @JsonKey(name: 'errors_list')
    @Default([]) List<ErrorItemDataModel>? error,
  }) = _AppErrorDataModel;

  factory AppErrorDataModel.fromJson(Map<String, dynamic> json) =>
      _$AppErrorDataModelFromJson(json);
}