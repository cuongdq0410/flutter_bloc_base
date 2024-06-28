import 'package:dio/dio.dart';
import 'package:flutter_skyway_example/config/constants.dart';
import 'package:flutter_skyway_example/data/remote/api/app_api.dart';
import 'package:flutter_skyway_example/data/remote/exception_mapper.dart';
import 'package:flutter_skyway_example/data/repository/auth_repository_impl.dart';
import 'package:flutter_skyway_example/data/repository/user_repository_impl.dart';
import 'package:flutter_skyway_example/data/storage/shared_pref_manager.dart';
import 'package:flutter_skyway_example/domain/repository/auth_repository.dart';
import 'package:flutter_skyway_example/domain/repository/user_repository.dart';
import 'package:flutter_skyway_example/domain/usecases/usecases.dart';
import 'package:flutter_skyway_example/domain/usecases/user_usecase.dart';
import 'package:flutter_skyway_example/injection/injector.dart';
import 'package:flutter_skyway_example/ui/login/bloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/remote/builder/dio_builder.dart';
import '../data/socket/socket_service.dart';

class DataModules {
  static Future<void> inject() async {
    injector.registerLazySingleton<Dio>(
      Dio.new,
    );

    /// Local storage
    injector
      ..registerSingletonAsync<SharedPreferences>(() async {
        return SharedPreferences.getInstance();
      })
      ..registerLazySingleton<SharedPreferencesManager>(
        () => SharedPreferencesManager(injector.get<SharedPreferences>()),
      )

      /// Network client
      ..registerLazySingleton<AppApi>(
        () => AppApi(
          DioBuilder.getInstance(),
          baseUrl: Constants.shared().endpoint,
        ),
      )

      ///Socket
      ..registerLazySingleton<SocketService>(
        SocketService.new,
      )
      ..registerFactory<ExceptionMapper>(
        ExceptionMapper.new,
      );

    /// Repository
    injectRepository();

    /// UsesCase
    injectUsesCase();

    injectBloc();
  }

  static void injectRepository() {
    injector.registerFactory<AuthRepository>(AuthRepositoryImpl.new);
    injector.registerFactory<UserRepository>(
      () => UserRepositoryImpl(injector.get<ExceptionMapper>()),
    );
  }

  static void injectUsesCase() {
    injector.registerFactory<AuthUseCase>(
      () => AuthUseCase(injector.get<AuthRepository>()),
    );
    injector.registerFactory<UserUseCase>(
      () => UserUseCase(injector.get<UserRepository>()),
    );
  }

  static void injectBloc() {
    injector.registerFactory<LoginBloc>(
      () => LoginBloc(injector.get<AuthUseCase>()),
    );
  }
}
