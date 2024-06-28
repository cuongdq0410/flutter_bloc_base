class ErrorDataModel {
  final int? errorCode;
  final String? message;
  final List<ErrorModel>? errors;

  const ErrorDataModel({
    this.errorCode,
    this.message,
    this.errors,
  });
}

class ErrorModel {
  final String value;
  final String msg;
  final String param;
  final String location;

  const ErrorModel({
    required this.value,
    required this.msg,
    required this.param,
    required this.location,
  });
}
