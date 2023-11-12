import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/home/delegates/search_community_delegate.dart';
import 'package:dialogix/features/home/drawers/community_list_drawer.dart';
import 'package:dialogix/features/home/drawers/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
        centerTitle: false,
        leading: Builder(
          builder: (ctx) => IconButton(
              onPressed: () => displayDrawer(ctx),
              icon: const Icon(Icons.menu)),
        ),
        actions: [
          IconButton(
              onPressed: () => communitySearch(context),
              icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          Builder(
            builder: (ctx) => IconButton(
                onPressed: () => displayEndDrawer(ctx),
                icon: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.profilePic),
                )),
          )
        ],
      ),
      body: Center(child: Text(user.name)),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }
}
