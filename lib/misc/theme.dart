import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var baseTheme = ThemeData(
  colorScheme: const ColorScheme.light(surface: Colors.white),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
);

const String imageDefaultUser = "assets/images/no_user.jpg";
const String imageDefaultData = "assets/images/no_data.png";
