import 'dart:io';

import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../../../theme/palette.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  File? _bannerFile;
  Uint8List? _bannerWebFile;
  List<CommunityModel> _communities = [];
  CommunityModel? _selectedCommunity;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        _bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        _bannerFile != null &&
        _titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          ctx: context,
          title: _titleController.text.trim(),
          selectedCommunity: _selectedCommunity ?? _communities[0],
          file: _bannerFile);
    } else if (widget.type == 'text' && _titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          ctx: context,
          title: _titleController.text.trim(),
          selectedCommunity: _selectedCommunity ?? _communities[0],
          description: _descriptionController.text.trim());
    } else if (widget.type == 'link' &&
        _linkController.text.isNotEmpty &&
        _titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          ctx: context,
          title: _titleController.text.trim(),
          selectedCommunity: _selectedCommunity ?? _communities[0],
          link: _linkController.text.trim());
    } else {
      showSnackBar(context, "Field can't be empty");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text(("Share")),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0).w,
              child: Column(children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Enter Title here',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20).w,
                  ),
                  maxLength: 30,
                ),
                Gap(12.h),
                if (isTypeImage)
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: currentTheme.textTheme.bodyMedium!.color!,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: double.infinity,
                            height: 120.h,
                            child: _bannerFile != null
                                ? Image.file(
                                    _bannerFile!,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    ),
                                  ),
                          )),
                    ),
                  ),
                if (isTypeText)
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter Description here',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20).w,
                    ),
                    maxLines: 5,
                  ),
                if (isTypeLink)
                  TextField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter link here',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20).w,
                    ),
                  ),
                Gap(20.h),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Select Community',
                  ),
                ),
                ref.watch(userCommunitiesProvider).when(
                    data: (data) {
                      _communities = data;
                      if (data.isEmpty) {
                        return const SizedBox();
                      }
                      return DropdownButton(
                          value: _selectedCommunity ?? data[0],
                          alignment: Alignment.centerRight,
                          style: TextStyle(
                              color: currentTheme.textTheme.bodyMedium!.color!),
                          items: data
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.name,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCommunity = val));
                    },
                    error: (err, trace) => Text(err.toString()),
                    loading: () => const Loader())
              ]),
            ),
    );
  }
}
