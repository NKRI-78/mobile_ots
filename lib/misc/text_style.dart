import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyles {
  static TextStyle textStyleBold = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
    fontFamily: 'Poppins',
  );
  static TextStyle textStyleNormal = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.whiteColor,
    fontFamily: 'Poppins',
  );
  static TextStyle textStyleSmall = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.whiteColor,
    fontFamily: 'Poppins',
  );

  AppTextStyles._();
}
