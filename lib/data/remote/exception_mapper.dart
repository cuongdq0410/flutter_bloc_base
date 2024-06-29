import 'package:dio/dio.dart';
import 'package:flutter_skyway_example/data/app_error.dart';
import 'package:flutter_skyway_example/data/models/annotation/tag.dart';
import 'package:flutter_skyway_example/data/models/exception/base_exception.dart';
import 'package:flutter_skyway_example/data/models/exception/inline_exception.dart';
import 'package:flutter_skyway_example/data/models/exception/toast_exception.dart';

import '../models/error/error_item_data_model.dart';

abstract class BaseExceptionMapper<T extends AppError,
    R extends BaseException> {
  Future<R> mapperTo(T error);

  Future<T> mapperFrom(R exception);
}

class ExceptionMapper extends BaseExceptionMapper<AppError, BaseException> {
  @override
  Future<AppError> mapperFrom(BaseException exception) =>
      throw UnimplementedError();

  @override
  Future<BaseException> mapperTo(AppError error) async {
    if (error is DioException) error = AppError.from(error as DioException);
    switch (error.type) {
      case AppErrorType.network:
        return ToastException(-1, 'Check your network');

      case AppErrorType.server:
        if (error.errors?.length == 1) {
          return await mapperFromSingleError(error.errors!.first);
        } else if ((error.errors?.length ?? 0) > 1) {
          return await mapperFromMultipleErrors(error.errors!);
        } else {
          return ToastException(-1, error.message);
        }
      case AppErrorType.unauthorized:
      case AppErrorType.unknown:
      case AppErrorType.cancel:
      case AppErrorType.timeout:
      default:
        return ToastException(-1, error.message);
    }
  }

  Future<BaseException> mapperFromSingleError(
    ErrorItemDataModel errorDataModel,
  ) async {
    return ToastException(0, errorDataModel.errorMessage!);
  }

  // Multiple exception only with inline exception so need return only type inline
  Future<BaseException> mapperFromMultipleErrors(
      List<ErrorItemDataModel> errors) async {
    final tagList = await _mapperFromErrors(errors);
    return InlineException(
      -1,
      'multiple errors will appear to check multiple fields',
      tags: tagList,
    );
  }

  Future<List<Tag>> _mapperFromErrors(List<ErrorItemDataModel> errors) async {
    final tags = <Tag>[];
    for (final error in errors) {
      tags.add(Tag('0', message: error.errorMessage));
    }

    return tags;
  }
}
