import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/auth/controller/auth_controller.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});

  void signInWithGoogle(WidgetRef ref, BuildContext ctx) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(ctx, isFromLogin);
  }

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0).w,
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref, context),
        icon: Image.asset(
          Constants.googlePath,
          width: 35.w,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Palette.greyColor,
            minimumSize: Size(ScreenUtil().screenWidth, 40.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
