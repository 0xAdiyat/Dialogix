import 'package:cached_network_image/cached_network_image.dart';
import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate({required this.ref});
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query.toLowerCase())).when(
        data: (communities) => ListView.builder(
              itemBuilder: (ctx, index) {
                final community = communities[index];
                return ListTile(
                  title: Text(
                    "r/${community.name}",
                  ),
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(community.avatar),
                    radius: 15,
                  ),
                  onTap: () => navigateToCommunity(ctx, community.name),
                );
              },
              itemCount: communities.length,
            ),
        error: (err, stackTrace) => Text(err.toString()),
        loading: () => Loader());
  }

  void navigateToCommunity(BuildContext ctx, String communityName) {
    Routemaster.of(ctx).push("/r/$communityName");
  }
}
