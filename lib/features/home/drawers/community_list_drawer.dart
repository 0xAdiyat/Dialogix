import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext ctx) {
    Routemaster.of(ctx).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text("Create a community"),
              leading: Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(
                data: (communities) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        final community = communities[index];
                        return ListTile(
                          title: Text("r/${community.name}"),
                          leading: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(community.avatar),
                            radius: 15,
                          ),
                          onTap: () {},
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
