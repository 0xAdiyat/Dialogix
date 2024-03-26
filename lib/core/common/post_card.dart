import 'dart:ui';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/common/widgets/dialogix_cached_network_image.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:dialogix/models/user_model.dart';
import 'package:dialogix/responsive/responsive.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../utils.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  static const double kBorderRadiusValue = 12.0;
  static const double kTwelveValue = 12.0;
  static const double kPostPaddingValue = 16.0;
  static const double kPostPaddingHalfValue = kPostPaddingValue / 2;
  static const double avatarRadius = 20.0;
  static const double kCardOpacityAboveBlurredEffect = 0.65;
  static const double blurredImageHeightFactor = 0.12;
  static const double blurredImageWidthFactor = 0.76;
  static const double blurredImageSizeFactor = 0.20;
  static const double actionButtonHeight = 30.0;
  static const double kFontSizeValue = 16.0;
  static const double kSigmaXY = 24.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final user = ref.watch(userProvider)!;
    final mode = ref.watch(themeNotifierProvider.notifier).mode;
    final currentTheme = ref.watch(themeNotifierProvider);
    final isGuest = !user.isAuthenticated;
    final textTheme = Theme.of(context).textTheme;

    return Responsive(
      child: Padding(
        padding: const EdgeInsets.all(kTwelveValue).w,
        child: Stack(
          children: [
            if (isTypeImage) _buildBlurredImage(post.link!),
            Container(
              padding: const EdgeInsets.symmetric(
                      vertical: kPostPaddingValue,
                      horizontal: kPostPaddingHalfValue)
                  .w,
              decoration: BoxDecoration(
                color: _getBackgroundColor(mode),
                borderRadius: BorderRadius.circular(kBorderRadiusValue),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                              horizontal: kPostPaddingValue)
                          .w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserInfo(post, user, context, ref, textTheme),
                          if (post.awards.isNotEmpty) ...[
                            Gap(4.h),
                            SizedBox(
                              height: 24.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final award = post.awards[index];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 20,
                                  );
                                },
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                    vertical: kPostPaddingHalfValue)
                                .w,
                            child: Text(post.title,
                                style: textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          _buildPostContent(
                              post, mode, currentTheme, textTheme),
                          Gap(kTwelveValue.h),
                          _buildPostActions(post, user, ref, context, isGuest),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
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
            height: ScreenUtil().screenHeight * blurredImageHeightFactor,
            width: ScreenUtil().screenWidth * blurredImageWidthFactor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kTwelveValue),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: kSigmaXY,
              sigmaY: kSigmaXY,
            ),
            child: Container(
              height: ScreenUtil().screenHeight * blurredImageSizeFactor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(ThemeMode mode) {
    return mode == ThemeMode.light
        ? Colors.white.withOpacity(kCardOpacityAboveBlurredEffect)
        : Palette.glassBlack.withOpacity(kCardOpacityAboveBlurredEffect);
  }

  Widget _buildUserInfo(PostModel post, UserModel user, BuildContext context,
      WidgetRef ref, TextTheme textTheme) {
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
                    radius: avatarRadius,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("d/${post.communityName}",
                          style: textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                      GestureDetector(
                        onTap: () => navigateToUser(context),
                        child: Text("u/${post.username}",
                            style: textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => showBottomDrawerMenu(context, ref, post, user),
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

  Widget _buildPostContent(PostModel post, ThemeMode mode,
      ThemeData currentTheme, TextTheme textTheme) {
    if (post.type == 'image') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(kTwelveValue),
        child: SizedBox(
          height: ScreenUtil().screenHeight * blurredImageSizeFactor,
          width: double.infinity,
          child: DialogixCachedNetworkImage(
            imgUrl: post.link!,
          ),
        ),
      );
    } else if (post.type == 'link') {
      return Padding(
        padding: const EdgeInsets.symmetric(
                horizontal: kTwelveValue, vertical: kPostPaddingHalfValue)
            .w,
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
        padding: const EdgeInsets.symmetric(
                horizontal: kPostPaddingValue, vertical: kPostPaddingHalfValue)
            .w,
        child: Text(
          post.description!,
          style: textTheme.bodyMedium!.copyWith(color: Colors.grey),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildPostActions(PostModel post, UserModel user, WidgetRef ref,
      BuildContext context, bool isGuest) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kTwelveValue),
            border: Border.all(
              color: Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: isGuest ? () {} : () => upvote(ref),
                icon: SvgPicture.asset(
                  height: actionButtonHeight,
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
                style: const TextStyle(fontSize: kFontSizeValue),
              ),
              IconButton(
                onPressed: isGuest ? () {} : () => downvote(ref),
                icon: SvgPicture.asset(
                  height: actionButtonHeight,
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
              style: const TextStyle(fontSize: kFontSizeValue),
            ),
          ],
        ),
        // TODO: Add mods button as more options
        ref.watch(getCommunityByNameProvider(post.communityName)).when(
            data: (community) {
              if (community.mods.contains(user.uid)) {
                return IconButton(
                  onPressed: () => deletePost(ref, context, true),
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
        Flexible(
          child: IconButton(
            onPressed: isGuest
                ? () {}
                : () {
                    showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(20).w,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemCount: user.awards.length,
                            itemBuilder: (BuildContext context, int index) {
                              final award = user.awards[index];

                              return GestureDetector(
                                onTap: () => awardPost(ref, award, context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0).w,
                                  child: Image.asset(Constants.awards[award]!),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
            icon: SvgPicture.asset(
              Constants.giftIcon,
              colorFilter: ColorFilter.mode(Colors.grey[300]!, BlendMode.srcIn),
            ),
          ),
        ),
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

  void deletePost(WidgetRef ref, BuildContext ctx, [bool isAdminDel = false]) {
    ref.read(postControllerProvider.notifier).deletePost(post, ctx, isAdminDel);
  }

  void upvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext ctx) => ref
      .read(postControllerProvider.notifier)
      .awardPost(post: post, award: award, ctx: ctx);

  void createAndCopyLink(BuildContext ctx, WidgetRef ref) => ref
      .read(postControllerProvider.notifier)
      .createPostDynamicLink(ctx, post);

  void showBottomDrawerMenu(
      BuildContext context, WidgetRef ref, PostModel post, UserModel user) {
    final screenWidth = ScreenUtil().screenWidth;
    final themeCtx = Theme.of(context);

    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (BuildContext context) {
        return Container();
      },
    );
//TODO: Converting image to widget so that user can download it
    showCupertinoModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      expand: true,
      builder: (BuildContext context) {
        Widget buildFlexibleDivider(double dimension, bool isVertical) {
          return Container(
            color: themeCtx.colorScheme.background,
            height: isVertical ? dimension : 1,
            width: isVertical ? 1 : dimension,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.clear),
              ),
            ),
            const Spacer(),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0)
                      .w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: SizedBox(
                          height: screenWidth * 1.5,
                          width: screenWidth,
                          child: CachedNetworkImage(
                              imageUrl: post.link ?? post.communityProfilePic,
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
                Container(
                  height: screenWidth * 0.952,
                  width: screenWidth * 0.70,
                  decoration: BoxDecoration(
                    color: themeCtx.iconTheme.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 16.0)
                            .w,
                        child: Text(
                          formatDateTime(post.createdAt),
                          style: themeCtx.textTheme.bodySmall!.copyWith(
                            color: themeCtx.colorScheme.background,
                          ),
                        ),
                      ),
                      buildFlexibleDivider(screenWidth * 0.70, false),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200.w,
                            height: 212.h,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0).w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    post.title,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        themeCtx.textTheme.titleLarge!.copyWith(
                                      color: themeCtx.colorScheme.background,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (post.description != null)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 4.0).w,
                                      child: Text(
                                        post.description!,
                                        style: themeCtx.textTheme.titleSmall!
                                            .copyWith(
                                          color:
                                              themeCtx.colorScheme.background,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 6,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          buildFlexibleDivider(screenWidth * 0.67, true),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 12.0).w,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                "d/@${post.communityName}",
                                style: themeCtx.textTheme.titleSmall!.copyWith(
                                  color: themeCtx.colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      buildFlexibleDivider(screenWidth * 0.70, false),
                      Padding(
                        padding: const EdgeInsets.all(12.0).w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      user.profilePic),
                                  radius: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0)
                                      .copyWith(left: 8)
                                      .w,
                                  child: SizedBox(
                                    width: screenWidth * 0.35,
                                    child: Text(
                                      user.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: themeCtx.textTheme.titleSmall!
                                          .copyWith(
                                        color: themeCtx.colorScheme.background,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              Constants.dialogixLogoPath,
                              height: 34,
                              width: 34,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0).copyWith(bottom: 40).w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(children: [
                      const Icon(
                        CupertinoIcons.pen,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0).w,
                        child: Text("Edit post",
                            style: themeCtx.textTheme.bodySmall),
                      )
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => deletePost(ref, context),
                    child: Column(children: [
                      const Icon(
                        CupertinoIcons.trash,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0).w,
                        child:
                            Text("Delete", style: themeCtx.textTheme.bodySmall),
                      )
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => createAndCopyLink(context, ref),
                    child: Column(children: [
                      const Icon(
                        CupertinoIcons.link,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0).w,
                        child: Text("Copy link",
                            style: themeCtx.textTheme.bodySmall),
                      )
                    ]),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(children: [
                      const Icon(
                        CupertinoIcons.share,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0).w,
                        child: Text("Share via...",
                            style: themeCtx.textTheme.bodySmall),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
