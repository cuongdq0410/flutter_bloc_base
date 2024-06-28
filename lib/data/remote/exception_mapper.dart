import 'package:flutter_skyway_example/data/app_error.dart';
import 'package:flutter_skyway_example/data/models/annotation/tag.dart';
import 'package:flutter_skyway_example/data/models/error/error_data_model.dart';
import 'package:flutter_skyway_example/data/models/exception/base_exception.dart';
import 'package:flutter_skyway_example/data/models/exception/inline_exception.dart';
import 'package:flutter_skyway_example/data/models/exception/toast_exception.dart';

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
    switch (error.type) {
      case AppErrorType.network:
        return ToastException(-1, 'Check your network');

      case AppErrorType.server:
        if (error.errorDataModel?.errors?.length == 1) {
          return ToastException(
              0, error.errorDataModel?.errors?.first.msg ?? error.message);
        } else if ((error.errorDataModel?.errors?.length ?? 0) > 1) {
          String messageError =
              error.errorDataModel?.errors?.map((e) => '${e.msg}').join(', ') ??
                  error.message;
          return ToastException(0, messageError);
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
    ErrorDataModel errorDataModel,
  ) async {
    switch (errorDataModel.errorCode) {
      case 1000:
      default:
        return ToastException(
            errorDataModel.errorCode!, errorDataModel.message!);
    }
  }

  // Multiple exception only with inline exception so need return only type inline
  Future<BaseException> mapperFromMultipleErrors(
      List<ErrorDataModel> errors) async {
    final tagList = await _mapperFromErrors(errors);
    return InlineException(
      -1,
      'multiple errors will appear to check multiple fields',
      tags: tagList,
    );
  }

  Future<List<Tag>> _mapperFromErrors(List<ErrorDataModel> errors) async {
    final tags = <Tag>[];
    for (final error in errors) {
      tags.add(Tag(error.errorCode!.toString(), message: error.message));
    }

    return tags;
  }
}
