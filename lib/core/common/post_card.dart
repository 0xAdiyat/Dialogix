import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:dialogix/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 12).w,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16)
                            .w
                            .copyWith(right: 0)
                            .w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              post.communityProfilePic),
                                      radius: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8).w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("r/${post.communityName}",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold)),
                                          Text("u/${post.username}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete_outline,
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
                              SizedBox(
                                height: ScreenUtil().screenHeight * 0.35,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
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
                                    horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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
