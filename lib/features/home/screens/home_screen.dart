import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/feed/widgets/category_tabs.dart';
import 'package:dialogix/features/home/delegates/search_community_delegate.dart';
import 'package:dialogix/features/home/drawers/community_list_drawer.dart';
import 'package:dialogix/features/home/drawers/profile_drawer.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void displayDrawer(BuildContext ctx) {
    Scaffold.of(ctx).openDrawer();
  }

  void displayEndDrawer(BuildContext ctx) {
    Scaffold.of(ctx).openEndDrawer();
  }

  void onPageChanged(int page) => setState(() => _page = page);
  void communitySearch(BuildContext context) =>
      showSearch(context: context, delegate: SearchCommunityDelegate(ref: ref));
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final currentMode = ref.watch(themeNotifierProvider.notifier).mode;

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Home',
        ),
        centerTitle: false,
        leading: Builder(
          builder: (ctx) => IconButton(
              onPressed: () => displayDrawer(ctx),
              icon: const Icon(CupertinoIcons.command)),
        ),
        actions: [
          IconButton(
              onPressed: () => communitySearch(context),
              icon: SvgPicture.asset(
                Constants.searchIcon,
                colorFilter: ColorFilter.mode(
                    currentTheme.iconTheme.color!, BlendMode.srcIn),
              )),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_outlined)),
          Builder(
            builder: (ctx) => IconButton(
                onPressed: () => displayEndDrawer(ctx),
                icon: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.profilePic),
                )),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(4.h),
          CategoryTabs(currentMode: currentMode),
          Gap(4.h),
          Expanded(child: Constants.tabWidgets[_page]),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar:
          isGuest ? null : _buildBottomNavigationBar(currentTheme, currentMode),
    );
  }

  CupertinoTabBar _buildBottomNavigationBar(
      ThemeData currentTheme, ThemeMode mode) {
    return CupertinoTabBar(
      backgroundColor:
          mode == ThemeMode.light ? Colors.white : Palette.glassBlack,
      activeColor: currentTheme.iconTheme.color,
      height: kTextTabBarHeight + 16,
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 16.0).w,
            child: Column(
              children: [
                SvgPicture.asset(
                  Constants.homeIcon,
                  colorFilter: ColorFilter.mode(
                      currentTheme.iconTheme.color!, BlendMode.srcIn),
                ),
                if (_page == 0)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ).w,
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: currentTheme.iconTheme.color,
                    ),
                  ),
              ],
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: _page != 1 ? 20.0 : 16.0).w,
            child: Column(
              children: [
                const Icon(CupertinoIcons.pencil_outline),
                if (_page == 1)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ).w,
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: currentTheme.iconTheme.color,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
      onTap: onPageChanged,
      currentIndex: _page,
    );
  }
}
