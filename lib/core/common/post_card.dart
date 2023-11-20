import 'dart:ui';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:dialogix/models/user_model.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controller/auth_controller.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final user = ref.watch(userProvider)!;
    final mode = ref.watch(themeNotifierProvider.notifier).mode;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0).w,
      child: Stack(
        children: [
          if (isTypeImage) _buildBlurredImage(post.link!),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8).w,
            decoration: BoxDecoration(
              color: _getBackgroundColor(mode),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16).w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserInfo(post, user, context, ref),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0).w,
                          child: Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildPostContent(post, mode, currentTheme),
                        Gap(12.h),
                        _buildPostActions(post, user, ref, context),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredImage(String imageUrl) {
    return Positioned(
      right: 40,
      left: 40,
      bottom: -8,
      child: Stack(
        children: [
          Container(
            height: ScreenUtil().screenHeight * 0.12,
            width: ScreenUtil().screenWidth * 0.76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 24,
              sigmaY: 24,
            ),
            child: Container(
              height: ScreenUtil().screenHeight * 0.20,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(ThemeMode mode) {
    return mode == ThemeMode.light
        ? Colors.white.withOpacity(0.7)
        : Palette.glassBlack.withOpacity(0.7);
  }

  Widget _buildUserInfo(
      PostModel post, UserModel user, BuildContext context, WidgetRef ref) {
    return Column(
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
                        CachedNetworkImageProvider(post.communityProfilePic),
                    radius: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("d/${post.communityName}",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => navigateToUser(context),
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
                icon: SvgPicture.asset(
                  Constants.moreIcon,
                  colorFilter:
                      const ColorFilter.mode(Palette.redColor, BlendMode.srcIn),
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _buildPostContent(
      PostModel post, ThemeMode mode, ThemeData currentTheme) {
    if (post.type == 'image') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: ScreenUtil().screenHeight * 0.20,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: post.link!,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (post.type == 'link') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0).w,
        child: Card(
          child: AnyLinkPreview(
            removeElevation: true,
            titleStyle: TextStyle(color: currentTheme.iconTheme.color),
            backgroundColor:
                mode == ThemeMode.light ? Colors.white : Palette.glassBlack,
            displayDirection: UIDirection.uiDirectionHorizontal,
            link: post.link!,
          ),
        ),
      );
    } else if (post.type == 'text') {
      return Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).w,
        child: Text(
          post.description!,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return const SizedBox(); // Handle other post types if needed
    }
  }

  Widget _buildPostActions(
      PostModel post, UserModel user, WidgetRef ref, BuildContext context) {
    return Row(
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
                icon: SvgPicture.asset(
                  height: 30,
                  Constants.arrowUpIcon,
                  colorFilter: ColorFilter.mode(
                      post.upvotes.contains(user.uid)
                          ? Palette.redColor
                          : Colors.grey[300]!,
                      BlendMode.srcIn),
                ),
              ),
              Text(
                '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: () => downvote(ref),
                icon: SvgPicture.asset(
                  height: 30,
                  Constants.arrowBottomIcon,
                  colorFilter: ColorFilter.mode(
                      post.downvotes.contains(user.uid)
                          ? Palette.blueColor
                          : Colors.grey[300]!,
                      BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => navigateToComments(context),
              icon: SvgPicture.asset(
                Constants.commentIcon,
                colorFilter:
                    ColorFilter.mode(Colors.grey[300]!, BlendMode.srcIn),
              ),
            ),
            Text(
              '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        ref.watch(getCommunityByNameProvider(post.communityName)).when(
            data: (community) {
              if (community.mods.contains(user.uid)) {
                return IconButton(
                  onPressed: () => deletePost(ref),
                  icon: SvgPicture.asset(
                    Constants.modIcon,
                    colorFilter:
                        ColorFilter.mode(Colors.grey[300]!, BlendMode.srcIn),
                  ),
                );
              }
              return const SizedBox();
            },
            error: (err, stack) => ErrorText(err.toString()),
            loading: () => const Loader()),
      ],
    );
  }

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
}
