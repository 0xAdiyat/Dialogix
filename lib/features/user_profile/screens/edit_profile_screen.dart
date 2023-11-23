import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/user_profile/controller/user_profile_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/palette.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfileScreen> {
  File? _bannerFile;
  File? _profileFile;

  Uint8List? _bannerWebFile;
  Uint8List? _profileWebFile;

  late TextEditingController _usernameController;
  @override
  void initState() {
    _usernameController =
        TextEditingController(text: ref.read(userProvider)!.name);
    super.initState();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          _bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          _bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          _profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          _profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save(BuildContext ctx) =>
      ref.read(userProfileControllerProvider.notifier).editProfile(
          ctx: ctx,
          profileFile: _profileFile,
          bannerFile: _bannerFile,
          profileWebFile: _profileWebFile,
          bannerWebFile: _bannerWebFile,
          username: _usernameController.text.trim());

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) => Scaffold(
              // backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text("Edit Profile"),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(context),
                    child: const Text("Save"),
                  )
                ],
              ),
              body: isLoading
                  ? const Loader()
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
                                      color: currentTheme
                                          .textTheme.bodyMedium!.color!,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 120.h,
                                          child: _bannerWebFile != null
                                              ? Image.memory(
                                                  _bannerWebFile!,
                                                  fit: BoxFit.cover,
                                                )
                                              : _bannerFile != null
                                                  ? Image.file(
                                                      _bannerFile!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : user.banner.isEmpty ||
                                                          user.banner ==
                                                              Constants
                                                                  .bannerDefault
                                                      ? const Center(
                                                          child: Icon(
                                                            Icons
                                                                .camera_alt_outlined,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl: user.banner,
                                                          fit: BoxFit.cover,
                                                        ),
                                        ),
                                      )),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: _profileWebFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(_profileWebFile!),
                                            radius: 32,
                                          )
                                        : _profileFile != null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    FileImage(_profileFile!),
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
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Palette.blueColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.all(16).w,
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
