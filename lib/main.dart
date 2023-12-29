import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/models/user_model.dart';
import 'package:dialogix/router.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routemaster/routemaster.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future.delayed(const Duration(seconds: 2));

  FlutterNativeSplash.remove();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: DialogixApp()));
}

class DialogixApp extends ConsumerStatefulWidget {
  const DialogixApp({super.key});

  @override
  ConsumerState createState() => _DialogixAppState();
}

class _DialogixAppState extends ConsumerState<DialogixApp> {
  UserModel? userModel;
  bool _isLoading = false;
  void getData(WidgetRef ref, User data) async {
    _isLoading = true;

    userModel = await ref
        .read(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first; // bcz it's a stream, so in order to convert it to future we have to use first

    ref.read(userProvider.notifier).update((state) => userModel);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return ref.watch(authStateChangeProvider).when(
            data: (data) => MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Dialogix',
                  theme: ref.watch(themeNotifierProvider),
                  routerDelegate: RoutemasterDelegate(routesBuilder: (ctx) {
                    if (data != null) {
                      getData(ref, data);
                      if (userModel != null && ref.read(userProvider) != null) {
                        return loggedInRoute;
                      }
                    }
                    if (_isLoading) {
                      return loaderRoute;
                    } else {
                      return loggedOutRoute;
                    }
                  }),
                  routeInformationParser: const RoutemasterParser(),
                ),
            error: (err, stackTrace) => ErrorText(err.toString()),
            loading: () => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ref.watch(themeNotifierProvider),
                builder: (ctx, _) => const Scaffold(body: Loader())));
      },
    );
  }
}
