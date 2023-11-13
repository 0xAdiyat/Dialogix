import 'package:dialogix/core/common/loader.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/community/controller/community_controller.dart';
import 'package:dialogix/features/community/providers/selected_uids_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String communityName;
  const AddModsScreen({super.key, required this.communityName});

  @override
  ConsumerState createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int counter = 0;
  void addUid(String uid, WidgetRef ref) =>
      ref.read(selectedUidsProvider(uids)).addUid(uid);
  void removeUid(String uid, WidgetRef ref) =>
      ref.read(selectedUidsProvider(uids)).removeUid(uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.done))],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.communityName)).when(
          data: (community) => ListView.builder(
                itemBuilder: (ctx, index) {
                  final memberUid = community.members[index];
                  return ref.watch(getUserDataProvider(memberUid)).when(
                      data: (user) {
                        if (community.mods.contains(memberUid) &&
                            counter == 0) {
                          // addUid(memberUid); // it cant be used in here as we are calling setState and setState cant be used in build, otherwise it will cause infinite loop
                          uids.add(memberUid);
                        }
                        counter++;
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUid(user.uid, ref);
                            } else {
                              removeUid(user.uid, ref);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (err, trace) => Text(err.toString()),
                      loading: () => Loader());
                },
                itemCount: community.members.length,
              ),
          error: (err, trace) => Text(err.toString()),
          loading: () => Loader()),
    );
  }
}
