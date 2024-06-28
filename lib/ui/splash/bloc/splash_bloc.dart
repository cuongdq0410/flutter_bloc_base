import 'package:bloc/bloc.dart';
import 'package:flutter_skyway_example/data/storage/session_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/user_usecase.dart';
import '../../utils/device_info_util.dart';
import '../models/app_version_data.dart';

part 'splash_event.dart';

part 'splash_state.dart';

part 'splash_bloc.freezed.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final UserUseCase _userUseCase;

  SplashBloc(this._userUseCase) : super(const SplashState.init()) {
    on<_GetVersion>((event, emit) async {
      try {
        final response = await _userUseCase.getAppVersion();
        final localVersion = await DeviceInfoUtil.getAppVersion();
        String remoteVersion = response.version ?? '1.0.0';
        if (!(await DeviceInfoUtil.isAppOutdated(remoteVersion))) {
          checkLoginStatus(emit);
        } else {
          emit(
            SplashState.updateApp(
              versionData: AppVersionData(
                localVersion,
                remoteVersion,
                false,
                () {
                  checkLoginStatus(emit);
                },
              ),
            ),
          );
        }
      } on Exception catch (ex) {
        emit(
          SplashState.retryGetVersion(messageError: ex.toString()),
        );
      }
    });
  }

  checkLoginStatus(Emitter<SplashState> emit) async {
    final token = SessionUtils.getAccessToken();
    if (token.isEmpty) {
      emit(const SplashState.unAuthenticate());
    } else {
      emit(const SplashState.authenticate());
    }
  }
}
