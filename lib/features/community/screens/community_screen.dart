import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';

class CommunityScreen extends ConsumerWidget {
  final String communityName;
  const CommunityScreen({super.key, required this.communityName});

  void navigateToModScreen(BuildContext ctx) =>
      Routemaster.of(ctx).push('/mod-tools/$communityName');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(communityName)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 120.h,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                          child: CachedNetworkImage(
                        imageUrl: community.banner,
                        fit: BoxFit.cover,
                      ))
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16).w,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(community.avatar),
                          radius: 35,
                        ),
                      ),
                      Gap(5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'r/${community.name}',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: community.mods.contains(user.uid)
                                ? () => navigateToModScreen(context)
                                : () {},
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text(community.mods.contains(user.uid)
                                ? "Mod Tools"
                                : community.members.contains(user.uid)
                                    ? "Joined"
                                    : "Join"),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10).w,
                        child: Text(
                          '${community.members.length} members',
                        ),
                      ),
                    ]),
                  ),
                )
              ],
              body: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Container(
                    child: const Text("Displaying post"),
                  );
                },
                itemCount: 1,
              ),
            ),
            error: (Object error, StackTrace stackTrace) =>
                Text(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
