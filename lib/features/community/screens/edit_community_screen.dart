import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/widgets/dialogix_cached_network_image.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/core/utils.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/models/community_model.dart';
import 'package:dialogix/responsive/responsive.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String communityName;
  const EditCommunityScreen({super.key, required this.communityName});

  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? _bannerFile;
  File? _avatarFile;
  Uint8List? _bannerWebFile;
  Uint8List? _avatarWebFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() async {
          _bannerWebFile = await res.readAsBytes();
        });
      } else {
        setState(() {
          _bannerFile = File(res.path);
        });
      }
    }
  }

  void selectAvatarImage() async {
    final res = await pickImage(cropStyle: CropStyle.circle);
    if (res != null) {
      if (kIsWeb) {
        setState(() async {
          _avatarWebFile = await res.readAsBytes();
        });
      } else {
        setState(() {
          _avatarFile = File(res.path);
        });
      }
    }
  }

  void save(CommunityModel community, BuildContext ctx) =>
      ref.read(communityControllerProvider.notifier).editCommunity(
          community: community,
          ctx: ctx,
          avatarFile: _avatarFile,
          bannerFile: _bannerFile,
          bannerWebFile: _bannerWebFile,
          avatarWebFile: _avatarWebFile);

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.communityName)).when(
        data: (community) => Scaffold(
              // backgroundColor: currentTheme.backgroundColor,
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
                  ? const Loader()
                  : Responsive(
                      child: Padding(
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
                                        color: currentTheme
                                            .textTheme.bodyMedium!.color!,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 120.h,
                                            child: _bannerWebFile != null
                                                ? Image.memory(_bannerWebFile!)
                                                : _bannerFile != null
                                                    ? Image.file(
                                                        _bannerFile!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : community.banner
                                                                .isEmpty ||
                                                            community.banner ==
                                                                Constants
                                                                    .bannerDefault
                                                        ? const Center(
                                                            child: Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              size: 40,
                                                            ),
                                                          )
                                                        : DialogixCachedNetworkImage(
                                                            imgUrl: community
                                                                .banner),
                                          ),
                                        )),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectAvatarImage,
                                      child: _avatarWebFile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  MemoryImage(_avatarWebFile!),
                                              radius: 32,
                                            )
                                          : _avatarFile != null
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      FileImage(_avatarFile!),
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
            ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Loader());
  }
}
