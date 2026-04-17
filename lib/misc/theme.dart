import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var baseTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFFf0f2f8),
  colorScheme: ColorScheme.light(
    surface: Color(0xFFf0f2f8),
    primary: Color(0xff1A73E9),
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Color(0xFFf0f2f8),
      backgroundColor: Color(0xff1A73E9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
);

const String imageDefaultUser = "assets/images/no_user.jpg";
const String imageDefaultData = "assets/images/no_data.png";
