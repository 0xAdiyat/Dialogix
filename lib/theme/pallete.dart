import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Color(0xfff8f8f8);
  static const redColor = Color(0xffff4500);
  static const blueColor = Color(0xff0079d3);

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    textTheme: GoogleFonts.latoTextTheme()
        .apply(displayColor: whiteColor, bodyColor: whiteColor),
    // textTheme: Theme.of(context)
    //     .textTheme
    //     .apply(fontFamily: 'Gilroy'),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: Pallete.whiteColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500),
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    useMaterial3: true,
    primaryColor: redColor,
    backgroundColor:
        drawerColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    useMaterial3: true,
    textTheme: GoogleFonts.latoTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: whiteColor,
      titleTextStyle: TextStyle(
          color: Pallete.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500),
      elevation: 0,
      iconTheme: const IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,

    // backgroundColor: whiteColor,
    colorScheme: ColorScheme.fromSeed(seedColor: redColor),
  );
}
