
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../providers/dynamic_link/firebase_dynamic_link_repository_provider.dart';

final dynamicLinkControllerProvider =
    StateNotifierProvider<DynamicLinkController, bool>((ref) {
  return DynamicLinkController(ref: ref);
});

class DynamicLinkController extends StateNotifier<bool> {
  final Ref _ref;

  DynamicLinkController({required Ref ref})
      : _ref = ref,
        super(false);

  void initDynamicLink(BuildContext ctx) async {
    final resUri = await _ref
        .read(firebaseDynamicLinkRepositoryProvider)
        .initDynamicLink();

    resUri.fold((l) => null, (r) {
      final isPost = r.pathSegments.contains("post");
      if (isPost) {
        final postIdSegment = r.pathSegments[1];
        final postId = postIdSegment.split('=')[1];
        if (postId.isNotEmpty) {
          Routemaster.of(ctx).push('/post/$postId/comments');
        } else {
          Routemaster.of(ctx).push('/error');
        }
      }
    });
  }
}
