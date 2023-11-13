import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});
  void navigateToEditUserProfileScreen(BuildContext ctx) =>
      Routemaster.of(ctx).push('/edit-profile/$uid');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 180.h,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: user.banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding:
                            const EdgeInsets.all(12).w.copyWith(bottom: 60).w,
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(user.profilePic),
                          radius: 35,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(12).w,
                        child: OutlinedButton(
                            onPressed: () =>
                                navigateToEditUserProfileScreen(ctx),
                            child: const Text("Edit Profile"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Pallete.whiteColor.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)))),
                      )
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16).w,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'r/${user.name}',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10).w,
                        child: Text(
                          '${user.karma} karma',
                        ),
                      ),
                      Gap(10.h),
                      Divider(
                        thickness: 2,
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