import 'package:dio/dio.dart';
import 'package:flutter_skyway_example/data/request/login_request.dart';
import 'package:flutter_skyway_example/data/response/login_response.dart';
import 'package:flutter_skyway_example/data/response/version_info_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../response/api_base_response.dart';

part 'app_api.g.dart';

@RestApi()
abstract class AppApi {
  factory AppApi(Dio dio, {String baseUrl}) = _AppApi;

  @POST("/login-v2")
  Future<ApiResponse<LoginResponse>> login(@Body() LoginRequest loginRequest);

  @GET('/version')
  Future<VersionInfoResponse> getAppVersion(@Query('platform') String platform);
}
