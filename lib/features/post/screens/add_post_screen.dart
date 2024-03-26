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

/// A screen to select post type before adding a post.
class AddPostScreen extends ConsumerWidget {
  /// A screen to select post type before adding a post.
  const AddPostScreen({super.key});

  /// Navigates to add post screen for the given [type].
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

  /// Share the post according to its type.
  ///
  /// Calls the appropriate share function from [PostController].
  void sharePost(
    WidgetRef ref,
  ) {
    final currentPostType = ref.watch(postTypeControllerProvider).postType;
    final post = ref.watch(postTypeControllerProvider);

    // Image post
    if (currentPostType == PostType.image &&
        (post.bannerFile != null || post.bannerWebFile != null) &&
        _titleController.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareImagePost(
        ctx: context,
        title: _titleController.text.trim(),
        selectedCommunity: _selectedCommunity ?? _communities[0],
        file: post.bannerFile,
        webFile: post.bannerWebFile,
      );

    // Text post
    } else if (currentPostType == PostType.text &&
        _titleController.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareTextPost(
        ctx: context,
        title: _titleController.text.trim(),
        selectedCommunity: _selectedCommunity ?? _communities[0],
        description: _descriptionController.text.trim(),
      );
      _titleController.clear();
      _descriptionController.clear();

    // Link post
    } else if (currentPostType == PostType.link &&
        _linkController.text.isNotEmpty &&
        _titleController.text.isNotEmpty) {
      ref
          .read(postControllerProvider.notifier)
          .shareLinkPost(
        ctx: context,
        title: _titleController.text.trim(),
        selectedCommunity: _selectedCommunity ?? _communities[0],
        link: _linkController.text.trim(),
      );
      _titleController.clear();
      _linkController.clear();

    // Video post
    } else if (currentPostType == PostType.video) {
      showSnackBar(context, "Stay tuned!");

    // Empty fields
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
  /// The TextField for adding posts with detected links and text styling.
  ///
  /// This widget wraps a [DetectableTextField] and provides an input field for
  /// users to add posts. It has a hint text, detected text styling, and a
  /// clear button. The detected text is also limited to a certain number of
  /// characters.
  ///
  /// The [onSubmitted] callback is called when the user submits the field
  /// with the detected input. The [keyboardType] is the type of keyboard that
  /// should be shown when the user is typing. The [maxLines] is the maximum
  /// number of lines the user is allowed to input. If not provided, it is set
  /// to 4 if [enableCounter] is true and null otherwise. The [controller] is
  /// the controller for the text field. The [enableCounter] is a boolean that
  /// determines whether the field should have a character counter or not.
  /// The [enableClearFunction] is a boolean that determines whether the field
  /// should have a clear button or not. The [hintText] is the hint text to be
  /// shown in the field. The [overallTextStyle] is the overall text style for
  /// the field. The [counterMax] is the maximum allowed number of characters
  /// for the detected text.
  Widget build(BuildContext context) {
    return DetectableTextField(
      /// Called when the user submits the field with the detected input.
      onSubmitted: onSubmitted,

      /// The overall text style for the field.
      style: _overallTextStyle,

      /// The minimum number of lines to be displayed.
      minLines: 1,

      /// The type of keyboard to display.
      keyboardType: keyboardType,

      /// The maximum number of lines to be displayed.
      ///
      /// If not provided, it is set to 4 if [enableCounter] is true and null
      /// otherwise.
      maxLines: maxLines ?? (_enableCounter ? 4 : null),

      /// The controller for the text field.
      controller: _controller,

      /// The decoration for the text field.
      decoration: InputDecoration(
        /// The suffix widget to be placed inside the decoration's container.
        suffix: _enableClearFunction
            ? IconButton(
                /// The size of the icon inside the button.
                iconSize: 16,

                /// The style of the button.
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color?>(
                        Palette.glassWhite)),

                /// The icon to be displayed inside the button.
                icon: const Icon(
                  CupertinoIcons.clear,
                ),

                /// The callback to be called when the button is pressed.
                onPressed: () => _controller.clear(),
              )
            : null,

        /// The hint text to be displayed inside the field.
        hintText: _hintText,

        /// The style of the hint text.
        hintStyle: _overallTextStyle.copyWith(
            color: _overallTextStyle.color!.withOpacity(0.4)),

        /// The border of the field.
        border: InputBorder.none,

        /// The padding inside the field.
        contentPadding: _enableClearFunction
            ? const EdgeInsets.all(20).copyWith(right: 12).w
            : const EdgeInsets.all(20).w,
      ),

      /// The maximum number of characters allowed for the detected input.
      ///
      /// If not provided, it is set to [counterMax].
      maxLength: _enableCounter ? counterMax : null,
    );
  }
}
