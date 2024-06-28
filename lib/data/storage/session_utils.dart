
import 'package:flutter_skyway_example/injection/injector.dart';

import 'shared_pref_manager.dart';

class SessionUtils {
  static void saveAccessToken(String accessToken) =>
      injector.get<SharedPreferencesManager>().putString(
            SharedPreferenceKey.keyAccessToken,
            accessToken,
          );

  static String getAccessToken() =>
      injector<SharedPreferencesManager>()
          .getString(SharedPreferenceKey.keyAccessToken) ??
      '';

  static Future<void> clearSession() async {
    await injector<SharedPreferencesManager>()
        .removeByKey(SharedPreferenceKey.keyAccessToken);
    await injector<SharedPreferencesManager>()
        .removeByKey(SharedPreferenceKey.keyRefreshToken);
  }

  static void saveRefreshToken(String accessToken) =>
      injector<SharedPreferencesManager>().putString(
        SharedPreferenceKey.keyRefreshToken,
        accessToken,
      );

  static String getRefreshToken() =>
      injector<SharedPreferencesManager>()
          .getString(SharedPreferenceKey.keyRefreshToken) ??
      '';
}
