import 'package:flutter_skyway_example/domain/repository/user_repository.dart';

import '../../data/response/version_info_response.dart';

class UserUseCase {
  final UserRepository _repository;

  UserUseCase(this._repository);

  Future<VersionInfoResponse> getAppVersion() {
    return _repository.getAppVersion();
  }
}
