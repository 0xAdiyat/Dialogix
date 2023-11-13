import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String communityName;
  const ModToolsScreen({super.key, required this.communityName});
  void navigateToEditCommunityScreen(BuildContext ctx) =>
      Routemaster.of(ctx).push('/edit-community/$communityName');

  void navigateToAddModsScreen(BuildContext ctx) =>
      Routemaster.of(ctx).push('/add-mods/$communityName');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text("Add Moderators"),
            onTap: () => navigateToAddModsScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Community"),
            onTap: () => navigateToEditCommunityScreen(context),
          ),
        ],
      ),
    );
  }
}
