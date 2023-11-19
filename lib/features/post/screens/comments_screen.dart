import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/core/common/post_card.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) => Column(children: [
              PostCard(post: post),
            ]),
            error: (error, stackTrace) {
              return ErrorText(
                error.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
