import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../community/controller/community_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider(user.uid)).when(
            data: (communities) {
              return FirestoreListView(
                physics: const BouncingScrollPhysics(),
                pageSize: 5,
                query: ref.read(userPostsPaginationQueryProvider(communities)),
                emptyBuilder: (context) => const Text('No data'),
                errorBuilder: (context, error, stackTrace) =>
                    Text(error.toString()),
                loadingBuilder: (context) => const Loader(),
                itemBuilder: (context, doc) {
                  final post = doc.data();

                  return PostCard(post: post);
                },
              );
            },
            error: (error, stackTrace) => ErrorText(
              error.toString(),
            ),
            loading: () => const Loader(),
          );
    }
    return ref.watch(guestPostsProvider).when(
          data: (posts) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
            error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
