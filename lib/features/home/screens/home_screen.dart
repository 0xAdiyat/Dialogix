import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/home/drawers/community_list_drawer.dart';
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
              onPressed: () => displayDrawer(ctx), icon: Icon(Icons.menu)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          Builder(
            builder: (ctx) => IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.profilePic),
                )),
          )
        ],
      ),
      body: Center(child: Text(user.name)),
      drawer: const CommunityListDrawer(),
    );
  }
}
