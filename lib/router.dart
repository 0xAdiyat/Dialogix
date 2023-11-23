import 'package:dialogix/core/constants/route_paths.dart';
import 'package:dialogix/features/auth/screens/login_screen.dart';
import 'package:dialogix/features/community/screens/add_mods_screen.dart';
import 'package:dialogix/features/community/screens/community_screen.dart';
import 'package:dialogix/features/community/screens/create_community_screen.dart';
import 'package:dialogix/features/community/screens/edit_community_screen.dart';
import 'package:dialogix/features/community/screens/mod_tools_screen.dart';
import 'package:dialogix/features/home/screens/home_screen.dart';
import 'package:dialogix/features/post/screens/add_post_screen.dart';
import 'package:dialogix/features/post/screens/add_post_type_screen.dart';
import 'package:dialogix/features/post/screens/comments_screen.dart';
import 'package:dialogix/features/user_profile/screens/edit_profile_screen.dart';
import 'package:dialogix/features/user_profile/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'core/common/loader.dart';

final loaderRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: Scaffold(body: Loader()))},
);

final loggedOutRoute = RouteMap(
  routes: {
    RoutePaths.loginScreen: (_) => const MaterialPage(child: LoginScreen()),
  },
);
final loggedInRoute = RouteMap(
  onUnknownRoute: (_) => const Redirect('/'),
  routes: {
    RoutePaths.homeScreen: (_) => const MaterialPage(child: HomeScreen()),
    RoutePaths.createCommunityScreen: (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    RoutePaths.communityScreen: (route) => MaterialPage(
            child: CommunityScreen(
          communityName: route.pathParameters['community-name']!,
        )),
    RoutePaths.modToolsScreen: (route) => MaterialPage(
            child: ModToolsScreen(
          communityName: route.pathParameters['community-name']!,
        )),
    RoutePaths.editCommunityScreen: (route) => MaterialPage(
            child: EditCommunityScreen(
          communityName: route.pathParameters['community-name']!,
        )),
    RoutePaths.addModsScreen: (route) => MaterialPage(
            child: AddModsScreen(
          communityName: route.pathParameters['community-name']!,
        )),
    RoutePaths.userProfileScreen: (route) => MaterialPage(
            child: UserProfileScreen(
          uid: route.pathParameters['uid']!,
        )),
    RoutePaths.editProfileScreen: (route) => MaterialPage(
            child: EditProfileScreen(
          uid: route.pathParameters['uid']!,
        )),
    RoutePaths.addPostTypeScreen: (route) => MaterialPage(
            child: AddPostTypeScreen(
          type: route.pathParameters['type']!,
        )),
    RoutePaths.commentsScreen: (route) => MaterialPage(
            child: CommentsScreen(
          postId: route.pathParameters['postId']!,
        )),
    RoutePaths.addPostScreen: (_) => const MaterialPage(child: AddPostScreen()),
  },
);
