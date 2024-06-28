import '../../data/response/version_info_response.dart';

abstract class UserRepository {
  Future<VersionInfoResponse> getAppVersion();
}
