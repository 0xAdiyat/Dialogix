import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/common/post_card.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:dialogix/features/post/widgets/comment_card.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final _commentController = TextEditingController();

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

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) => Column(children: [
              PostCard(post: post),
              TextField(
                onSubmitted: (val) => addComment(post),
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'What are your thoughts?',
                  filled: true,
                  border: InputBorder.none,
                ),
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
