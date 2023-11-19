import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/post_card.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/user_profile/controller/user_profile_controller.dart';
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
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Palette.whiteColor.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Text("Edit Profile")),
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
                      const Divider(
                        thickness: 2,
                      ),
                    ]),
                  ),
                )
              ],
              body: ref.watch(getUserPostsProvider(uid)).when(
                  data: (posts) => ListView.builder(
                        itemBuilder: (ctx, index) =>
                            PostCard(post: posts[index]),
                        itemCount: posts.length,
                      ),
                  error: (err, trace) => ErrorText(err.toString()),
                  loading: () => const Loader()),
            ),
            error: (Object error, StackTrace stackTrace) =>
                Text(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
