import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfileScreen> {
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProvider)!;

    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) => Scaffold(
              backgroundColor: Pallete.lightModeAppTheme.colorScheme.background,
              appBar: AppBar(
                title: const Text("Edit Profile"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Save"),
                  )
                ],
              ),
              body: Padding(
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
                                      borderRadius: BorderRadius.circular(12)),
                                  child: _bannerFile != null
                                      ? Image.file(
                                          _bannerFile!,
                                          fit: BoxFit.cover,
                                        )
                                      : user.banner.isEmpty ||
                                              user.banner ==
                                                  Constants.bannerDefault
                                          ? const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: user.banner,
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
                                      backgroundImage: FileImage(_profileFile!),
                                      radius: 32,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.profilePic),
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
