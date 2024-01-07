import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/loader.dart';
import '../../../core/enums/post_type_enums.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../controller/post_controller.dart';
import '../controller/post_type_controller.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToTypeScreen(String type, BuildContext ctx) =>
      Routemaster.of(ctx).push('/add-post/$type');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final cardHeightWidth = kIsWeb ? 120.0.w : 120.0;
    // final iconSize = kIsWeb ? 60.0.w : 60.0;

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
            child: const AddAllPostScreen()));
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

  void sharePost(
    WidgetRef ref,
  ) {
    final currentPostType = ref.watch(postTypeControllerProvider).postType;
    final post = ref.watch(postTypeControllerProvider);
    if (currentPostType == PostType.image &&
        (post.bannerFile != null || post.bannerWebFile != null) &&
        _titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          ctx: context,
          title: _titleController.text.trim(),
          selectedCommunity: _selectedCommunity ?? _communities[0],
          file: post.bannerFile,
          webFile: post.bannerWebFile);
    } else if (currentPostType == PostType.text &&
        _titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          ctx: context,
          title: _titleController.text.trim(),
          selectedCommunity: _selectedCommunity ?? _communities[0],
          description: _descriptionController.text.trim());
      _titleController.clear();
      _descriptionController.clear();
    } else if (currentPostType == PostType.link &&
        _linkController.text.isNotEmpty &&
        _titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          ctx: context,
          title: _titleController.text.trim(),
          selectedCommunity: _selectedCommunity ?? _communities[0],
          link: _linkController.text.trim());
      _titleController.clear();
      _linkController.clear();
    } else if (currentPostType == PostType.video) {
      showSnackBar(context, "Stay tuned!");
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
    final uid = ref.read(userProvider)!.uid;

    final textTheme = Theme.of(context).textTheme;

    _titleController = DetectableTextEditingController(
      regExp: detectionRegExp(),
      detectedStyle: textTheme.titleLarge!.copyWith(color: Palette.redColor),
    );
    _descriptionController = DetectableTextEditingController(
      regExp: detectionRegExp(),
      detectedStyle: textTheme.bodyLarge!.copyWith(color: Palette.redColor),
    );
    _linkController = DetectableTextEditingController(
      regExp: detectionRegExp(),
      detectedStyle: textTheme.bodyLarge!.copyWith(color: Palette.redColor),
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
                      onPressed: () => sharePost(ref),
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
            overallStyle: textTheme.titleLarge!,
          ),
          Consumer(builder: (_, ref, widget) {
            // Post Type
            final currentPostType =
                ref.watch(postTypeControllerProvider).postType;
            final postController = ref.watch(postTypeControllerProvider);
            final postTypeNotifier =
                ref.read(postTypeControllerProvider.notifier);
            final isTypeImage = currentPostType == PostType.image;
            final isTypeText = currentPostType == PostType.text;
            final isTypeLink = currentPostType == PostType.link;
            final isTypeVideo = currentPostType == PostType.video;

            return Column(
              children: [
                if (isTypeText)
                  PostTextFieldWidget(
                    controller: _descriptionController,
                    overallStyle: textTheme.bodyLarge!,
                    hintText: "body text (optional)",
                  ),
                if (isTypeLink)
                  PostTextFieldWidget(
                    enableClearFunction: true,
                    controller: _linkController,
                    overallStyle: textTheme.bodyLarge!,
                    hintText: "Enter link",
                    maxLines: 1,
                  ),
                if (isTypeImage)
                  Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(bottom: 0).w,
                    child: GestureDetector(
                      onTap: () => postTypeNotifier.selectBannerImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: ScreenUtil().screenHeight * 0.20,
                          maxHeight: ScreenUtil().screenHeight * 0.50,
                        ),
                        child: postController.bannerWebFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  postController.bannerWebFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : postController.bannerFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      postController.bannerFile!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      CupertinoIcons.camera,
                                      size: 40,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                if (isTypeVideo)
                  Text("Not yet implemented!", style: textTheme.bodyLarge),
                Gap(12.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: isTypeLink
                            ? null
                            : () => postTypeNotifier.setPostTypeLink(),
                        icon: const Icon(CupertinoIcons.link),
                      ),
                      IconButton(
                        onPressed: isTypeText
                            ? null
                            : () => postTypeNotifier.setPostTypeText(),
                        icon: const Icon(CupertinoIcons.doc_text),
                      ),
                      IconButton(
                        onPressed: isTypeImage
                            ? null
                            : () => postTypeNotifier.setPostTypeImage(),
                        icon: const Icon(CupertinoIcons.photo),
                      ),
                      IconButton(
                        onPressed: isTypeVideo
                            ? null
                            : () => postTypeNotifier.setPostTypeVideo(),
                        icon: const Icon(CupertinoIcons.play_circle),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
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
    this.counterMax = 70,
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
  final int counterMax;
  @override
  Widget build(BuildContext context) {
    return DetectableTextField(
      onSubmitted: onSubmitted,
      style: _overallTextStyle,
      minLines: 1,
      keyboardType: keyboardType,
      maxLines: maxLines ?? (_enableCounter ? 4 : null),
      controller: _controller,
      decoration: InputDecoration(
        suffix: _enableClearFunction
            ? IconButton(
                iconSize: 16,
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color?>(Palette.glassWhite)),
                icon: const Icon(
                  CupertinoIcons.clear,
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
      maxLength: _enableCounter ? counterMax : null,
    );
  }
}
