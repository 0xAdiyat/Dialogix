import 'package:dialogix/features/auth/screens/login_screen.dart';
import 'package:dialogix/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const DialogixApp());
}

class DialogixApp extends StatelessWidget {
  const DialogixApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dialogix',
          theme: Pallete.darkModeAppTheme,
          home: child,
        );
      },
      child: LoginScreen(),
    );
  }
}
