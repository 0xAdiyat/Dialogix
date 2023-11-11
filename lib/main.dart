import 'package:dialogix/router.dart';
import 'package:dialogix/theme/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: DialogixApp()));
}

class DialogixApp extends StatelessWidget {
  const DialogixApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Dialogix',
          theme: Pallete.darkModeAppTheme,
          routerDelegate:
              RoutemasterDelegate(routesBuilder: (ctx) => loggedOutRout),
          routeInformationParser: const RoutemasterParser(),
        );
      },
    );
  }
}
