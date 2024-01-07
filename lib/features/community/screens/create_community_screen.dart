import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/features/post/screens/add_post_screen.dart';
import 'package:dialogix/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = DetectableTextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity(WidgetRef ref, BuildContext ctx) {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(ctx, communityNameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a community',
        ),
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PostTextFieldWidget(
                      enableCounter: true,
                      controller: communityNameController,
                      overallStyle: Theme.of(context).textTheme.bodyMedium!,
                      hintText: "d/community_name",
                      counterMax: 21,
                    ),
                    Gap(28.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: CupertinoButton(
                          color: Theme.of(context).iconTheme.color,
                          onPressed: () => createCommunity(ref, context),
                          child: Text("Create Community",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .background))),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
