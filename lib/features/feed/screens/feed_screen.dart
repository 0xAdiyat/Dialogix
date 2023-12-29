import 'package:dialogix/core/common/error_text.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/post/controller/post_controller.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';
import '../../../core/common/post_card.dart';
import '../../community/controller/community_controller.dart';

var scrollPositionProvider = StateProvider<double>((ref) => 0.0);

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late ScrollController _scrollController;
  int counter = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double currentOffset = _scrollController.offset;
    ref.read(scrollPositionProvider.notifier).state = currentOffset;
    print("saved offset onscroll: ${ref.read(scrollPositionProvider)}");
  }

  @override
  void dispose() {
    // Save the scroll position to the provider when disposing the screen
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollDown(WidgetRef ref) {
    _scrollController.animateTo(
      ref.read(scrollPositionProvider),
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    if (_scrollController.hasClients) {
      if (counter == 0) {
        _scrollDown(ref);
      }

      counter = 1;
    }

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider(user.uid)).when(
            data: (communities) {
              return communities.isNotEmpty
                  ? FirestoreListView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      pageSize: 5,
                      query: ref
                          .read(userPostsPaginationQueryProvider(communities)),
                      emptyBuilder: (context) => const Text('No data'),
                      errorBuilder: (context, error, stackTrace) =>
                          Text(error.toString()),
                      loadingBuilder: (context) => const Loader(),
                      itemBuilder: (context, doc) {
                        final post = doc.data();

                        return PostCard(post: post);
                      },
                    )
                  : ref.watch(guestPostsProvider).when(
                        data: (posts) {
                          return ListView.builder(
                            controller: _scrollController,
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
              controller: _scrollController,
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
