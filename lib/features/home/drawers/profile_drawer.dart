import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/palette.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) =>
      ref.read(authControllerProvider.notifier).logOut();

  void navigateToUserProfile(BuildContext ctx, String uid) =>
      Routemaster.of(ctx).push('/u/$uid');

  void toggleTheme(WidgetRef ref) =>
      ref.read(themeNotifierProvider.notifier).toggleTheme();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.profilePic),
              radius: 70,
            ),
            Gap(12.h),
            Text(
              "u/${user.name}",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            Gap(12.h),
            const Divider(),
            ListTile(
                title: const Text('My Profile'),
                leading: SvgPicture.asset(
                  Constants.userOctagonIcon,
                  colorFilter: ColorFilter.mode(
                      currentTheme.iconTheme.color!, BlendMode.srcIn),
                ),
                onTap: () => navigateToUserProfile(context, user.uid)),
            ListTile(
                title: const Text('Log Out'),
                leading: SvgPicture.asset(
                  Constants.logoutIcon,
                  colorFilter:
                      const ColorFilter.mode(Palette.redColor, BlendMode.srcIn),
                ),
                onTap: () => logOut(ref)),
            Switch.adaptive(
                value: ref.watch(themeNotifierProvider.notifier).mode ==
                        ThemeMode.dark
                    ? true
                    : false,
                onChanged: (val) => toggleTheme(ref))
          ],
        ),
      ),
    );
  }
}
