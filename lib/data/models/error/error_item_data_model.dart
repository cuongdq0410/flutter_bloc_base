import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_item_data_model.freezed.dart';
part 'error_item_data_model.g.dart';

@freezed
class ErrorItemDataModel with _$ErrorItemDataModel {
  const factory ErrorItemDataModel({
    @JsonKey(name: 'error_type') String? errorType,
    @JsonKey(name: 'error_message') String? errorMessage,
  }) = _ErrorItemDataModel;

  factory ErrorItemDataModel.fromJson(Map<String, Object?> json) =>
      _$ErrorItemDataModelFromJson(json);
}
