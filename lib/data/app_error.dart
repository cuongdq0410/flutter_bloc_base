import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'models/error/app_error_data_model.dart';
import 'models/error/error_item_data_model.dart';

enum AppErrorType {
  network,
  badRequest,
  unauthorized,
  notFound,
  cancel,
  timeout,
  server,
  unknown,
}

class AppError implements Equatable {
  final String message;
  final AppErrorType type;

  final int? headerCode;
  final List<ErrorItemDataModel>? errors;

  AppError(this.type, this.message, {int? code, List<ErrorItemDataModel>? err})
      : headerCode = code,
        errors = err;

  factory AppError.from(Exception error) {
    var type = AppErrorType.unknown;
    var message = '';
    int? headerCode;
    List<ErrorItemDataModel>? errors;

    if (error is DioException) {
      message = error.message ?? 'Error';
      headerCode = error.response?.statusCode ?? -1;

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          type = AppErrorType.timeout;
          break;
        case DioExceptionType.sendTimeout:
          type = AppErrorType.network;
          break;
        case DioExceptionType.badResponse:
          switch (error.response?.statusCode) {
            case HttpStatus.unauthorized: // 401
              type = AppErrorType.unauthorized;
              break;
            case HttpStatus.badRequest: // 400
            case HttpStatus.notFound: // 404
            case HttpStatus.methodNotAllowed: // 405
            case HttpStatus.unprocessableEntity: // 422
            case HttpStatus.internalServerError: // 500
            case HttpStatus.badGateway: // 502
            case HttpStatus.serviceUnavailable: // 503
            case HttpStatus.gatewayTimeout: // 504
              type = AppErrorType.server;

              try {
                final apiError = AppErrorDataModel.fromJson(
                    error.response?.data as Map<String, dynamic>);
                if (apiError.message is String) {
                  errors = [
                    ErrorItemDataModel(errorMessage: apiError.message),
                  ];
                }
                if (apiError.message is List) {
                  errors = (apiError.message as List).map(
                    (e) {
                      final errorItem = ErrorItemDataModel.fromJson(
                          e as Map<String, dynamic>);
                      return ErrorItemDataModel(
                        errorMessage: errorItem.errorMessage,
                      );
                    },
                  ).toList();
                } else if (apiError.message is Map) {
                  final errorItem = ErrorItemDataModel.fromJson(
                      apiError.message as Map<String, dynamic>);
                  errors = [
                    ErrorItemDataModel(
                      errorMessage: errorItem.errorMessage,
                    )
                  ];
                } else {
                  errors = [
                    ErrorItemDataModel(
                      errorMessage: apiError.message.toString(),
                    )
                  ];
                }
              } on Exception catch (e) {
                errors = [ErrorItemDataModel(errorMessage: e.toString())];
              }
            default:
              type = AppErrorType.unknown;
              break;
          }
        case DioExceptionType.cancel:
          type = AppErrorType.cancel;

        case DioExceptionType.unknown:
        default:
          if (error.error is SocketException) {
            type = AppErrorType.network;
          } else {
            type = AppErrorType.unknown;
          }
          break;
      }
    } else {
      type = AppErrorType.unknown;
      message = 'AppError: $error';
    }

    return AppError(type, message, code: headerCode, err: errors);
  }

  @override
  List<Object?> get props => [type, message, headerCode, errors];

  @override
  bool? get stringify => true;
}
