import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_skyway_example/data/models/error/app_error_data_model.dart';
import 'package:flutter_skyway_example/data/models/error/error_data_model.dart';

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
  final ErrorDataModel? errorDataModel;

  AppError(this.type, this.message, {int? code, ErrorDataModel? err})
      : headerCode = code,
        errorDataModel = err;

  factory AppError.from(Exception error) {
    var type = AppErrorType.unknown;
    var message = '';
    int? headerCode;
    ErrorDataModel? errorDataModel;

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
                final diorError = AppErrorDataModel.fromJson(
                    error.response?.data as Map<String, dynamic>);
                errorDataModel = diorError.toErrorDataModel();
              } on Exception catch (e) {
                errorDataModel =
                    ErrorDataModel(errorCode: -1, message: e.toString());
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

    return AppError(type, message, code: headerCode, err: errorDataModel);
  }

  @override
  List<Object?> get props => [type, message, headerCode, errorDataModel];

  @override
  bool? get stringify => true;
}
