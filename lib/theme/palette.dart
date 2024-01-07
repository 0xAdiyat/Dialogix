import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider.autoDispose<ThemeNotifier, ThemeData>(
        (ref) => ThemeNotifier());

class Palette {
  Palette._();
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Color(0xfff8f8f8);
  // static const redColor = Color(0xffff4500);
  static const redColor = Color(0xffFE1723);
  // static const redColor = blackColor;

  // static const redColor = Color(0xff951758);

  static const blueColor = Color(0xff0079d3);

  static const glassWhite = Color(0xffF1F1F1);
  static const glassBlack = Color(0xff0E0E0E);

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStatePropertyAll<TextStyle>(
                TextStyle(color: whiteColor)))),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: whiteColor),

    textTheme: GoogleFonts.latoTextTheme()
        .apply(displayColor: whiteColor, bodyColor: whiteColor),
    // textTheme: Theme.of(context)
    //     .textTheme
    //     .apply(fontFamily: 'Gilroy'),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
      backgroundColor: drawerColor,
    ),
    iconTheme: const IconThemeData(
      color: whiteColor,
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
      surfaceTintColor: drawerColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: drawerColor, backgroundColor: drawerColor),
    primaryColor: redColor,
    // backgroundColor: blackColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: whiteColor,
      brightness: Brightness.dark,
      background: blackColor,
    ),
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: blackColor),
    textTheme: GoogleFonts.latoTextTheme(),

    // dividerTheme: const DividerThemeData(color: blackColor),
    appBarTheme: AppBarTheme(
      backgroundColor: whiteColor,
      titleTextStyle: TextStyle(
          color: Palette.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500),
      elevation: 0,
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
      surfaceTintColor: whiteColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: whiteColor, backgroundColor: whiteColor),
    primaryColor: redColor,
    iconTheme: const IconThemeData(
      color: blackColor,
    ),
    // backgroundColor: whiteColor,
    colorScheme:
        ColorScheme.fromSeed(seedColor: redColor, background: whiteColor),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;

  ThemeNotifier({ThemeMode mode = ThemeMode.dark})
      : _mode = mode,
        super(Palette.darkModeAppTheme) {
    _getTheme();
  }

  ThemeMode get mode => _mode;

  void _getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
      prefs.setString('theme', 'dark');
    }
  }
}
