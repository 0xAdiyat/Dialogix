import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';
import '../../../models/community_model.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToTypeScreen(String type, BuildContext ctx) =>
      Routemaster.of(ctx).push('/add-post/$type');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardHeightWidth = kIsWeb ? 120.0.w : 120.0;
    final iconSize = kIsWeb ? 60.0.w : 60.0;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
            child: const AddAllPostScreen()));
  }

  Row _buildPostTypeRow(
      BuildContext context, double cardHeightWidth, double iconSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigateToTypeScreen('image', context),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToTypeScreen('text', context),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.font_download_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToTypeScreen('link', context),
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddAllPostScreen extends ConsumerStatefulWidget {
  const AddAllPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAllPostScreenState();
}

class _AddAllPostScreenState extends ConsumerState<AddAllPostScreen> {
  // Controller
  late DetectableTextEditingController _titleController;
  late DetectableTextEditingController _descriptionController;
  late DetectableTextEditingController _linkController;

  // Community model
  List<CommunityModel> _communities = [];
  CommunityModel? _selectedCommunity;

  // Type flags
  bool isTypeImage = false;
  bool isTypeText = true;
  bool isTypeLink = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(userProvider)!.uid;

    _titleController = DetectableTextEditingController(
      regExp: detectionRegExp(),
      detectedStyle: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: Palette.redColor),
    );
    _descriptionController = DetectableTextEditingController(
      regExp: detectionRegExp(),
      detectedStyle: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: Palette.redColor),
    );
    _linkController = DetectableTextEditingController(
      regExp: detectionRegExp(),
      detectedStyle: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: Palette.redColor),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0).w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ref.watch(userCommunitiesProvider(uid)).when(
                    data: (data) {
                      _communities = data;
                      if (data.isEmpty) {
                        return const SizedBox();
                      }
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                                height: 44,
                                width: 44,
                                fit: BoxFit.cover,
                                imageUrl: _selectedCommunity == null
                                    ? data[0].avatar
                                    : _selectedCommunity!.avatar),
                          ),
                          Gap(8.w),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: DropdownButton(
                                underline: Container(),
                                dropdownColor:
                                    Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(12.0),
                                value: _selectedCommunity ?? data[0],
                                alignment: Alignment.center,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!),
                                items: data
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            "d/${e.name}",
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedCommunity = val)),
                          ),
                        ],
                      );
                    },
                    error: (err, trace) => Text(err.toString()),
                    loading: () => const Loader()),
                SizedBox(
                  width: 154.w,
                  height: 40.h,
                  child: CupertinoButton(
                      color: Theme.of(context).iconTheme.color,
                      onPressed: () {},
                      child: Text("Share",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.background))),
                ),
              ],
            ),
          ),
          PostTextFieldWidget(
            controller: _titleController,
            enableCounter: true,
            overallStyle: Theme.of(context).textTheme.titleLarge!,
          ),
          if (isTypeText)
            PostTextFieldWidget(
              controller: _descriptionController,
              overallStyle: Theme.of(context).textTheme.bodyLarge!,
              hintText: "body text (optional)",
            ),
          if (isTypeLink)
            PostTextFieldWidget(
              enableClearFunction: true,
              controller: _descriptionController,
              overallStyle: Theme.of(context).textTheme.bodyLarge!,
              hintText: "Enter link",
              maxLines: 1,
            ),
          Gap(20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
            child: Row(
              children: [
                IconButton(
                  onPressed: isTypeLink
                      ? null
                      : () {
                          setState(() {
                            isTypeLink = true;
                            isTypeImage = false;
                            isTypeText = false;
                          });
                        },
                  icon: const Icon(CupertinoIcons.link),
                ),
                IconButton(
                  onPressed: isTypeText
                      ? null
                      : () {
                          setState(() {
                            isTypeLink = false;
                            isTypeImage = false;
                            isTypeText = true;
                          });
                        },
                  icon: const Icon(CupertinoIcons.doc_text),
                ),
                IconButton(
                  onPressed: isTypeImage
                      ? null
                      : () {
                          setState(() {
                            isTypeLink = false;
                            isTypeImage = true;
                            isTypeText = false;
                          });
                        },
                  icon: const Icon(CupertinoIcons.photo),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.play_circle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostTextFieldWidget extends StatelessWidget {
  const PostTextFieldWidget({
    super.key,
    required DetectableTextEditingController controller,
    bool enableCounter = false,
    bool enableClearFunction = false,
    String hintText = "Title",
    required TextStyle overallStyle,
    this.onSubmitted,
    this.keyboardType,
    this.maxLines,
  })  : _controller = controller,
        _enableCounter = enableCounter,
        _hintText = hintText,
        _overallTextStyle = overallStyle,
        _enableClearFunction = enableClearFunction;

  final DetectableTextEditingController _controller;
  final bool _enableCounter;
  final String _hintText;
  final TextStyle _overallTextStyle;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final bool _enableClearFunction;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return DetectableTextField(
      onSubmitted: onSubmitted,
      style: _overallTextStyle,
      minLines: 1,
      keyboardType: keyboardType,
      maxLines: maxLines ?? (_enableCounter ? 3 : null),
      controller: _controller,
      decoration: InputDecoration(
        suffix: _enableClearFunction
            ? IconButton(
                iconSize: 16,
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color?>(Palette.glassWhite)),
                icon: const Icon(
                  CupertinoIcons.xmark,
                ),
                onPressed: () => _controller.clear(),
              )
            : null,
        hintText: _hintText,
        hintStyle: _overallTextStyle.copyWith(
            color: _overallTextStyle.color!.withOpacity(0.4)),
        border: InputBorder.none,
        contentPadding: _enableClearFunction
            ? const EdgeInsets.all(20).copyWith(right: 12).w
            : const EdgeInsets.all(20).w,
      ),
      maxLength: _enableCounter ? 70 : null,
    );
  }
}
