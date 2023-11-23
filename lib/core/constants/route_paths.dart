class RoutePaths {
  RoutePaths._();
  static const loginScreen = '/';
  static const homeScreen = '/';
  static const createCommunityScreen = '/create-community';
  static const communityScreen = '/r/:community-name';
  static const modToolsScreen = '/mod-tools/:community-name';
  static const editCommunityScreen = '/edit-community/:community-name';
  static const addModsScreen = '/add-mods/:community-name';
  static const userProfileScreen = '/u/:uid';
  static const editProfileScreen = '/edit-profile/:uid';
  static const addPostTypeScreen = '/add-post/:type';
  static const commentsScreen = '/post/:postId/comments';
    static const addPostScreen = '/add-post';

}
