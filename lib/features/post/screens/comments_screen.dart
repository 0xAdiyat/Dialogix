import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/common/post_card.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:dialogix/features/post/screens/add_post_screen.dart';
import 'package:dialogix/features/post/widgets/comment_card.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final _commentController = DetectableTextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  void addComment(PostModel post) {
    ref
        .read(postControllerProvider.notifier)
        .addComment(ctx: context, text: _commentController.text, post: post);
    setState(() => _commentController.text = "");
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) => Column(children: [
              PostCard(post: post),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
                  child: Column(
                    children: [
                      if (!isGuest)
                        PostTextFieldWidget(
                          onSubmitted: (val) => addComment(post),
                          controller: _commentController,
                          hintText: "Add a comment",
                          overallStyle: Theme.of(context).textTheme.bodyMedium!,
                        ),
                      ref.watch(getPostCommentsProvider(widget.postId)).when(
                            data: (comments) => Expanded(
                              child: ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final comment = comments[index];
                                  return CommentCard(comment: comment);
                                },
                              ),
                            ),
                            error: (err, stackTrace) => ErrorText(
                              err.toString(),
                            ),
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                ),
              )
            ]),
            error: (error, stackTrace) => ErrorText(
              error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
