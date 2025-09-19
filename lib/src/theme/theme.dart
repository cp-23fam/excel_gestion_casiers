import 'package:flutter/material.dart';
import 'package:excel_gestion_casiers/src/constants/app_sizes.dart';

class AppColors {
  static Color primaryColor = const Color.fromRGBO(78, 87, 95, 1);
  static Color primaryAccent = const Color.fromRGBO(63, 70, 77, 1);
  static Color secondaryColor = const Color.fromRGBO(42, 48, 54, 1);
  static Color secondaryAccent = const Color.fromRGBO(33, 37, 41, 1);
  static Color titleColor = const Color.fromRGBO(200, 200, 200, 1);
  static Color textColor = const Color.fromARGB(255, 165, 165, 165);
  static Color iconColor = const Color.fromARGB(255, 255, 255, 255);

  static Color goodColor = const Color.fromRGBO(76, 175, 80, 1);
  static Color importantColor = const Color.fromARGB(255, 23, 143, 255);
  static Color editColor = const Color.fromARGB(255, 23, 143, 255);
  static Color deleteColor = const Color.fromRGBO(244, 67, 54, 1);
  static Color problemeColor = const Color.fromRGBO(244, 67, 54, 1);
  static Color warningColor = const Color.fromARGB(255, 234, 255, 44);
}

class AppBlueColors {
  static Color primaryColor = const Color.fromRGBO(141, 169, 196, 1);
  static Color primaryAccent = const Color.fromRGBO(19, 64, 116, 1);
  static Color secondaryColor = const Color.fromRGBO(19, 49, 92, 1);
  static Color secondaryAccent = const Color.fromRGBO(11, 37, 69, 1);
  static Color titleColor = const Color.fromRGBO(200, 200, 200, 1);
  static Color textColor = const Color.fromARGB(255, 165, 165, 165);
  static Color iconColor = const Color.fromARGB(255, 255, 255, 255);

  static Color importantColor = const Color.fromARGB(255, 23, 143, 255);
  static Color editColor = const Color.fromRGBO(76, 175, 80, 1);
  static Color deleteColor = const Color.fromRGBO(244, 67, 54, 1);
}

ThemeData primaryTheme = ThemeData(
  // seed color
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),

  // scaffold color
  scaffoldBackgroundColor: AppColors.secondaryAccent,

  // app bar theme colors
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.secondaryColor,
    foregroundColor: AppColors.textColor,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),

  // text
  textTheme: const TextTheme().copyWith(
    bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 1,
    ),
    headlineMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
    titleMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  ),

  // card theme
  cardTheme: CardThemeData(
    color: AppColors.secondaryColor,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(Sizes.p4),
    ),
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.only(bottom: Sizes.p16),
  ),

  // input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.secondaryColor.withValues(alpha: 0.5),
    border: InputBorder.none,
    labelStyle: TextStyle(color: AppColors.textColor),
    prefixIconColor: AppColors.textColor,
  ),

  // navigation decoration theme
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: AppColors.secondaryColor,
    selectedIconTheme: IconThemeData(color: AppColors.iconColor),
    unselectedIconTheme: IconThemeData(color: AppColors.iconColor),
    indicatorColor: AppColors.primaryColor,
  ),

  iconTheme: IconThemeData(color: AppColors.iconColor, size: Sizes.p32),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all<Color>(AppColors.iconColor),
      iconSize: WidgetStateProperty.all<double>(Sizes.p32),
    ),
  ),
);
