import 'package:enum_to_string/enum_to_string.dart';

enum Flavor { dev, stag, prod }

class Constants {
  const Constants({
    required this.endpoint,
    required this.socket,
    required this.packageName,
    required this.bundleId,
  });

  factory Constants.shared() {
    if (_instance != null) {
      return _instance!;
    }

    final flavor = EnumToString.fromString(
        Flavor.values, const String.fromEnvironment('FLAVOR'));
    switch (flavor) {
      case Flavor.prod:
        return Constants._prod();

      case Flavor.stag:
        return Constants._stag();

      case Flavor.dev:
      default:
        return Constants._dev();
    }
  }

  factory Constants._dev() {
    return const Constants(
      endpoint: 'http://stg-api-mipig-342327664.ap-northeast-1.elb.amazonaws.com/api/v2',
      socket: 'wss://socket-dev.voichat.com',
      packageName: 'jp.mipigcafe.mipig.v2.stg',
      bundleId: 'jp.mipig-cafe.mipig.v2.stg',
    );
  }

  factory Constants._stag() {
    return const Constants(
      endpoint: 'http://stg-api-mipig-342327664.ap-northeast-1.elb.amazonaws.com/api/v2',
      socket: 'wss://socket-dev.voichat.com',
      packageName: 'jp.mipigcafe.mipig.v2.stg',
      bundleId: 'jp.mipig-cafe.mipig.v2.stg',
    );
  }

  factory Constants._prod() {
    return const Constants(
      endpoint: 'http://stg-api-mipig-342327664.ap-northeast-1.elb.amazonaws.com/api/v2',
      socket: 'wss://socket-dev.voichat.com',
      packageName: 'jp.mipigcafe.mipig.v2',
      bundleId: 'jp.mipig-cafe.mipig.v2',
    );
  }

  final String endpoint;
  final String socket;
  final String packageName;
  final String bundleId;

  static Constants? _instance;
}

enum AuthenticateStatus { authenticated, unAuthenticate }
