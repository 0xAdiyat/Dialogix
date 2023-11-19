import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controller/auth_controller.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  const PostCard({
    super.key,
    required this.post,
  });

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  void deletePost(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).deletePost(post);
  }

  void upvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 12).w,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16)
                            .w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                post.communityProfilePic),
                                        radius: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8).w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("d/${post.communityName}",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold)),
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUser(context),
                                            child: Text("u/${post.username}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                      onPressed: () => deletePost(ref),
                                      icon: const Icon(Icons.delete_outline,
                                          color: Palette.redColor))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0).w,
                              child: Text(
                                post.title,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isTypeImage)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  height: ScreenUtil().screenHeight * 0.35,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: post.link!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ).w,
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Gap(5.h),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () => upvote(ref),
                                          icon: Icon(
                                              Icons.arrow_upward_outlined,
                                              size: 30,
                                              color: post.upvotes
                                                      .contains(user.uid)
                                                  ? Palette.redColor
                                                  : null)),
                                      Text(
                                        '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                          onPressed: () => downvote(ref),
                                          icon: Icon(
                                              Icons.arrow_downward_outlined,
                                              size: 30,
                                              color: post.downvotes
                                                      .contains(user.uid)
                                                  ? Palette.blueColor
                                                  : null)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          navigateToComments(context),
                                      icon: const Icon(
                                        Icons.comment_outlined,
                                      ),
                                    ),
                                    Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(getCommunityByNameProvider(
                                        post.communityName))
                                    .when(
                                        data: (community) {
                                          if (community.mods
                                              .contains(user.uid)) {
                                            return IconButton(
                                              onPressed: () => deletePost(ref),
                                              icon: const Icon(
                                                Icons
                                                    .admin_panel_settings_outlined,
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                        error: (err, stack) =>
                                            ErrorText(err.toString()),
                                        loading: () => const Loader()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ],
    );
  }
}
