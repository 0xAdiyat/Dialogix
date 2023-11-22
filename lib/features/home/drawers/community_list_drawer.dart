import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/sign_in_button.dart';
import 'package:dialogix/core/constants/route_paths.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';
import '../../auth/controller/auth_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext ctx) {
    Routemaster.of(ctx).push(RoutePaths.createCommunityScreen);
  }

  void navigateToCommunity(BuildContext ctx, String communityName) {
    Routemaster.of(ctx).push("/r/$communityName");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton(
                    isFromLogin: false,
                  )
                : ListTile(
                    title: const Text("Create a community"),
                    leading: const Icon(Icons.add),
                    onTap: () => navigateToCreateCommunity(context),
                  ),
            if (!isGuest)
              ref.watch(userCommunitiesProvider).when(
                  data: (communities) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          final community = communities[index];
                          return ListTile(
                            title: Text(
                              "d/${community.name}",
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(community.avatar),
                              radius: 15,
                            ),
                            onTap: () =>
                                navigateToCommunity(ctx, community.name),
                          );
                        },
                        itemCount: communities.length,
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const Loader())
          ],
        ),
      ),
    );
  }
}
