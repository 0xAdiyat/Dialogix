import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/core/constants/route_paths.dart';
import 'package:dialogix/core/controller/dynamic_link_controller.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/feed/screens/feed_screen.dart';
import 'package:dialogix/features/feed/widgets/category_tabs.dart';
import 'package:dialogix/features/home/delegates/search_community_delegate.dart';
import 'package:dialogix/features/home/drawers/community_list_drawer.dart';
import 'package:dialogix/features/home/drawers/profile_drawer.dart';
import 'package:dialogix/features/post/screens/add_post_screen.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController _pageController;

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

  void navigateToAddPostScreen(BuildContext ctx) =>
      Routemaster.of(ctx).push(RoutePaths.addPostScreen);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    ref.read(dynamicLinkControllerProvider.notifier).initDynamicLink(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final currentMode = ref.watch(themeNotifierProvider.notifier).mode;

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _page == 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(
                  kToolbarHeight), // Adjust height as needed
              child: FadeIn(
                child: AppBar(
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
                    if (kIsWeb)
                      IconButton(
                          onPressed: () => navigateToAddPostScreen(context),
                          icon: const Icon(Icons.add_outlined)),
                    Builder(
                      builder: (ctx) => IconButton(
                          onPressed: () => displayEndDrawer(ctx),
                          icon: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.profilePic),
                          )),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            if (_page == 0)
              Column(
                children: [
                  Gap(4.h),
                  CategoryTabs(currentMode: currentMode),
                  Gap(4.h),
                ],
              ),
            Expanded(
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: [
                  SlideInDown(child: const FeedScreen()),
                  SlideInUp(child: const AddPostScreen())
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : const ProfileDrawer(),
      bottomNavigationBar: isGuest || kIsWeb
          ? null
          : _buildBottomNavigationBar(currentTheme, currentMode),
    );
  }

  CupertinoTabBar _buildBottomNavigationBar(
    ThemeData currentTheme,
    ThemeMode mode,
  ) {
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
                    currentTheme.iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
                if (_page == 0)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ).w,
                    child: _buildCircleAvatarAnimation(currentTheme),
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
                    child: _buildCircleAvatarAnimation(currentTheme),
                  ),
              ],
            ),
          ),
        ),
      ],
      onTap: (index) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      currentIndex: _page,
    );
  }

  Widget _buildCircleAvatarAnimation(ThemeData currentTheme) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: CircleAvatar(
        radius: 3,
        backgroundColor: currentTheme.iconTheme.color,
      ),
    );
  }
}
