import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/common/sign_in_button.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40.h,
        ),
        actions: [TextButton(onPressed: () {}, child: Text("Skip"))],
      ),
      body: Center(
        child: isLoading
            ? const Loader()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(30.h),
                  Text(
                    "Dive into anything",
                    style: TextStyle(letterSpacing: 0.5.sp, fontSize: 24.sp),
                  ),
                  Gap(30.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0).w,
                    child: Image.asset(
                      Constants.loginEmotePath,
                      height: 200.h,
                    ),
                  ),
                  Gap(20.h),
                  const SignInButton(),
                ],
              ),
      ),
    );
  }
}
