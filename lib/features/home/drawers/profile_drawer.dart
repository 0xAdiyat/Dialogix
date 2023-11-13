import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) =>
      ref.read(authControllerProvider.notifier).logOut();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.profilePic),
              radius: 70,
            ),
            Gap(10.h),
            Text(
              "u/${user.name}",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
            Gap(10.h),
            const Divider(),
            ListTile(
                title: const Text('My Profile'),
                leading: const Icon(CupertinoIcons.person_alt),
                onTap: () {}),
            ListTile(
                title: const Text('Log Out'),
                leading: const Icon(
                  Icons.logout,
                  color: Pallete.redColor,
                ),
                onTap: () => logOut(ref)),
            Switch.adaptive(value: true, onChanged: (val) => {})
          ],
        ),
      ),
    );
  }
}
