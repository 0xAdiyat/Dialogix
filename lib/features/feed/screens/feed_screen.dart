// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    // TODO: Fix error user community provider is not being called during account switch requiring
    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) {
              return ref.watch(userPostsProvider(communities)).when(
                    data: (posts) {
                      return ListView.builder(
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
