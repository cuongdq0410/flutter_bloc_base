import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skyway_example/domain/usecases/usecases.dart';
import 'package:flutter_skyway_example/injection/injector.dart';
import 'package:flutter_skyway_example/ui/home/bloc/home_bloc.dart';
import 'package:flutter_skyway_example/ui/home/ui/home_screen.dart';
import 'package:flutter_skyway_example/ui/login/ui/login_screen.dart';
import 'package:flutter_skyway_example/ui/splash/bloc/splash_bloc.dart';
import 'package:flutter_skyway_example/ui/splash/ui/splash_screen.dart';

import '../../domain/usecases/user_usecase.dart';
import '../login/bloc/login_bloc.dart';

enum RouteDefine {
  splashScreen,
  loginScreen,
  forgotPasswordScreen,
  homeScreen,
}

class GenerateRoute {
  static PageRoute generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      RouteDefine.loginScreen.name: (_) => widgetBuilder(
            const LoginScreen(),
            bloc: LoginBloc(
              injector.get<AuthUseCase>(),
            ),
          ),
      RouteDefine.homeScreen.name: (_) => widgetBuilder(
            const HomeScreen(),
            bloc: HomeBloc(),
          ),
      RouteDefine.splashScreen.name: (_) => widgetBuilder(
            const SplashScreen(),
            bloc: SplashBloc(
              injector.get<UserUseCase>(),
            ),
          ),
    };

    final routeBuilder = routes[settings.name];
    return CupertinoPageRoute(
      settings: RouteSettings(name: settings.name),
      builder: (context) => routeBuilder!(context),
    );
  }

  static Widget widgetBuilder<T extends Bloc, S extends Widget>(
    S screen, {
    T? bloc,
  }) {
    return bloc == null
        ? screen
        : BlocProvider<T>(
            create: (context) => bloc,
            child: screen,
          );
  }

  static Widget widgetBuilderBlocValue<T extends Cubit, S extends Widget>(
    S screen, {
    T? cubit,
  }) {
    return cubit == null
        ? screen
        : BlocProvider<T>.value(
            value: cubit,
            child: screen,
          );
  }
}
