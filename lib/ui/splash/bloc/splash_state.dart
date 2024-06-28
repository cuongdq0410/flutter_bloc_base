part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.init() = Initial;

  const factory SplashState.authenticate() = Authenticate;

  const factory SplashState.unAuthenticate() = UnAuthenticate;

  const factory SplashState.updateApp({required AppVersionData versionData}) =
      UpdateApp;

  const factory SplashState.retryGetVersion({required String messageError}) =
      RetryGetVersion;

  const SplashState._();

  AppVersionData? get versionData =>
      mapOrNull(updateApp: (state) => state.versionData);
}
