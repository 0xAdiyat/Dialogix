import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/sign_in_button.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/core/constants/route_paths.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../delegates/search_community_delegate.dart';

class CommunityListDrawer extends ConsumerStatefulWidget {
  const CommunityListDrawer({super.key});

  @override
  ConsumerState createState() => _CommunityListDrawerState();
}

class _CommunityListDrawerState extends ConsumerState<CommunityListDrawer> {
  static const double iconSize = 28.0;
  static const double iconGap = 4.0;
  void navigateToCreateCommunity(BuildContext ctx) {
    Routemaster.of(ctx).push(RoutePaths.createCommunityScreen);
  }

  void navigateToCommunity(BuildContext ctx, String communityName) {
    Routemaster.of(ctx).push("/r/$communityName");
  }

  void navigateToUserProfile(BuildContext ctx, String uid) =>
      Routemaster.of(ctx).push('/u/$uid');
  Widget _buildDrawerIcons(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.time, size: iconSize),
          onPressed: () {
            // Handle onPressed
          },
        ),
        Gap(iconGap.h),
        IconButton(
          icon: const Icon(CupertinoIcons.dot_radiowaves_left_right,
              size: iconSize),
          onPressed: () {
            // Handle onPressed
          },
        ),
        Gap(iconGap.h),
        IconButton(
          icon: const Icon(CupertinoIcons.arrow_up_bin, size: iconSize),
          onPressed: () {
            // Handle onPressed
          },
        ),
        Gap(iconGap.h),
        IconButton(
          icon: const Icon(CupertinoIcons.star, size: iconSize),
          onPressed: () {
            // Handle onPressed
          },
        ),
        Gap(iconGap.h),
        IconButton(
            icon: SvgPicture.asset(
              Constants.userOctagonIcon,
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
              height: iconSize,
              width: iconSize,
            ),
            onPressed: () =>
                navigateToUserProfile(context, ref.watch(userProvider)!.uid)),
        Gap(iconGap.h),
        _buildUserAvatar(),
        Gap(iconGap.h),
        IconButton(
          icon: Icon(
            Icons.add,
            size: iconSize,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
          ),
          onPressed: () => navigateToCreateCommunity(context),
        ),
        const Spacer(),
        _buildActionIcons(context),
      ],
    );
  }

  Widget _buildActionIcons(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.question_circle, size: iconSize),
          onPressed: () {
            // Handle onPressed
          },
        ),
        Gap(iconGap.h),
        IconButton(
          icon: const Icon(CupertinoIcons.bell_solid, size: iconSize),
          onPressed: () {
            // Handle onPressed
          },
        ),
        Gap(iconGap.h),
        IconButton(
            icon: SvgPicture.asset(
              Constants.searchIcon,
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
              height: iconSize,
              width: iconSize,
            ),
            onPressed: () => communitySearch(context)),
        Gap(iconGap.h),
        IconButton(
          icon: SvgPicture.asset(
            Constants.settingsIcon,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
            height: iconSize,
            width: iconSize,
          ),
          onPressed: () {
            // Handle onPressed
          },
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      height: 48,
      width: 48,
      padding: const EdgeInsets.all(2).w,
      decoration: BoxDecoration(
        border: Border.all(
          color: Palette.redColor.withOpacity(0.4),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Palette.redColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "D",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Palette.whiteColor),
        ),
      ),
    );
  }

  Widget _buildUserListTile(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final isDarkMode = themeNotifier.mode == ThemeMode.dark;
    return ListTile(
      title: const Text("Create Community"),
      leading: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black26 : Colors.white54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.add,
        ),
      ),
      onTap: () => navigateToCreateCommunity(context),
    );
  }

  void communitySearch(BuildContext context) =>
      showSearch(context: context, delegate: SearchCommunityDelegate(ref: ref));

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      width: ScreenUtil().screenWidth,
      child: SafeArea(
        child: Row(
          children: [
            Container(
              height: double.maxFinite,
              width: 64,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4).w,
              child: _buildDrawerIcons(context),
            ),
            Expanded(
              child: Column(
                children: [
                  isGuest
                      ? const SignInButton(isFromLogin: false)
                      : _buildUserListTile(context, ref),
                  if (!isGuest)
                    ref.watch(userCommunitiesProvider(user.uid)).when(
                          data: (communities) {
                            return Expanded(
                              child: ListView.builder(
                                itemBuilder: (ctx, index) {
                                  final community = communities[index];
                                  return ListTile(
                                    title: Text("d/${community.name}"),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              community.avatar),
                                      radius: 16,
                                    ),
                                    onTap: () => navigateToCommunity(
                                        ctx, community.name),
                                  );
                                },
                                itemCount: communities.length,
                              ),
                            );
                          },
                          error: (error, stackTrace) => Text(error.toString()),
                          loading: () => const Loader(),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
