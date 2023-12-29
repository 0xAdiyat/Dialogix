import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/responsive/responsive.dart';
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
  final communityNameController = TextEditingController();

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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.name,
                      controller: communityNameController,
                      decoration: InputDecoration(
                        hintText: "d/community_name",
                        labelText: "Name",
                        filled: false,
                        contentPadding: const EdgeInsets.all(20).w,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLength: 21,
                    ),
                    Gap(28.h),
                    ElevatedButton(
                      onPressed: () => createCommunity(ref, context),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      child: Text(
                        'Create Community',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
