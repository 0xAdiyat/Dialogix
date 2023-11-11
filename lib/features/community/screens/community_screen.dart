import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/constants.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                    child: CachedNetworkImage(
                  imageUrl: Constants.bannerDefault,
                ))
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16).w,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(Constants.avatarDefault),
                    radius: 35,
                  ),
                ),
                Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'r/Anon',
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
                    '500 members',
                  ),
                ),
              ]),
            ),
          )
        ],
        body: ListView.builder(
          itemBuilder: (ctx, index) {
            return Container();
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
