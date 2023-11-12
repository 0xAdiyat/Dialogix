import 'package:dialogix/core/constants/route_paths.dart';
import 'package:dialogix/features/auth/screens/login_screen.dart';
import 'package:dialogix/features/community/screens/community_screen.dart';
import 'package:dialogix/features/community/screens/create_community_screen.dart';
import 'package:dialogix/features/community/screens/edit_community_screen.dart';
import 'package:dialogix/features/community/screens/mod_tools_screen.dart';
import 'package:dialogix/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    RoutePaths.loginScreen: (_) => const MaterialPage(child: LoginScreen()),
  },
);
final loggedInRoute = RouteMap(
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
  },
);
