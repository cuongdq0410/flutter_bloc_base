import 'package:flutter/material.dart';
import 'package:flutter_skyway_example/gen/colors.gen.dart';
import 'package:google_fonts/google_fonts.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

final ThemeData defaultTheme = ThemeData(
  primaryColor: ColorName.primaryColor,
  scaffoldBackgroundColor: ColorName.backgroundColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorName.primaryColor,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: ColorName.primaryColor, //thereby
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: ColorName.accentLightColor,
    disabledColor: ColorName.primaryColorDark,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: ColorName.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        )),
  ),
  textTheme: GoogleFonts.robotoTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xff232b4f),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 12,
    ),
    isDense: true,
    filled: true,
    fillColor: Color(0xffe5e7eb),
    //Color(0xff232b4f),
    labelStyle: TextStyle(
      fontSize: 12,
      color: Color(0xff979aaa),
    ),
  ),
);
