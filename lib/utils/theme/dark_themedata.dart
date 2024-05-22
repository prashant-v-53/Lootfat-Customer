import 'package:flutter/material.dart';
import 'package:lootfat_user/utils/colors.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.scffold,
      primaryColor: isDarkTheme ? AppColors.black : AppColors.white,
      indicatorColor: isDarkTheme ? AppColors.main : AppColors.scffold,
      hintColor: isDarkTheme ? AppColors.main : AppColors.scffold,
      highlightColor: AppColors.main,
      hoverColor: isDarkTheme ? AppColors.main : AppColors.scffold,
      focusColor: isDarkTheme ? AppColors.main : AppColors.scffold,
      disabledColor: AppColors.textLight,
      cardColor: isDarkTheme ? AppColors.main : AppColors.white,
      canvasColor: isDarkTheme ? AppColors.black : AppColors.scffold,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        backgroundColor: AppColors.main,
      ),
      fontFamily: "Montserrat",
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppColors.main,
          ),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: isDarkTheme ? AppColors.white : AppColors.black,
        cursorColor: AppColors.main,
      ),
    );
  }
}
