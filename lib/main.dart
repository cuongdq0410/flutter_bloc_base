import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_skyway_example/injection/dependency_manager.dart';
import 'package:flutter_skyway_example/ui/theme/theme.dart';
import 'package:flutter_skyway_example/ui/utils/keyboard_utils.dart';
import 'package:flutter_skyway_example/ui/widget/app_navigator.dart';
import 'package:flutter_skyway_example/ui/widget/route_define.dart';
import 'package:flutter_skyway_example/ui/widget/toast_message/toast_message.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyManager.inject();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    name: 'my-chat-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          darkTheme: defaultTheme,
          theme: defaultTheme,
          title: "Flutter Bloc Base",
          debugShowCheckedModeBanner: false,
          initialRoute: RouteDefine.splashScreen.name,
          onGenerateRoute: GenerateRoute.generateRoute,
          builder: _materialBuilder,
        );
      },
    );
  }

  Overlay _materialBuilder(BuildContext context, Widget? child) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            return Material(
              child: GestureDetector(
                onTap: () {
                  KeyboardUtils.hideKeyboard(context);
                },
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: toastBuilder(context, child!),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
