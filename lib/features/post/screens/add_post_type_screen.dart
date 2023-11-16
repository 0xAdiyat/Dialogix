import 'dart:io';

import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../../../theme/pallete.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(("Share")),
          )
        ],
      ),
      body: Padding(
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
          Gap(10.h),
          if (isTypeImage)
            GestureDetector(
              onTap: () {},
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
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                        ))),
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
              loading: () => Loader())
        ]),
      ),
    );
  }
}
