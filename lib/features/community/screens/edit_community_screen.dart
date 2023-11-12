import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/core/utils.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/models/community_model.dart';
import 'package:dialogix/theme/pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String communityName;
  const EditCommunityScreen({super.key, required this.communityName});

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? _bannerFile;
  File? _profileFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        _bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        _profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(CommunityModel community, BuildContext ctx) =>
      ref.read(communityControllerProvider.notifier).editCommunity(
          community: community,
          ctx: ctx,
          profileFile: _profileFile,
          bannerFile: _bannerFile);

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.watch(getCommunityByNameProvider(widget.communityName)).when(
        data: (community) => Scaffold(
              backgroundColor: Pallete.lightModeAppTheme.colorScheme.background,
              appBar: AppBar(
                title: const Text("Edit Community"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(community, context),
                    child: const Text("Save"),
                  )
                ],
              ),
              body: isLoading
                  ? Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160.h,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectBannerImage,
                                  child: DottedBorder(
                                      radius: const Radius.circular(12),
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      borderType: BorderType.RRect,
                                      color: Pallete.lightModeAppTheme.textTheme
                                          .bodyLarge!.color!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 120.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: _bannerFile != null
                                            ? Image.file(
                                                _bannerFile!,
                                                fit: BoxFit.cover,
                                              )
                                            : community.banner.isEmpty ||
                                                    community.banner ==
                                                        Constants.bannerDefault
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 40,
                                                    ),
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: community.banner,
                                                    fit: BoxFit.cover,
                                                  ),
                                      )),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: _profileFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                FileImage(_profileFile!),
                                            radius: 32,
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    community.avatar),
                                            radius: 32,
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Loader());
  }
}