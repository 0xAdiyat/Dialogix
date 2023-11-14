import 'dart:io';

import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/user_profile/repository/user_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final profileRepository = ref.read(userProfileRepositoryProvider);
  final storageRepository = ref.read(storageRepositoryProvider);
  return UserProfileController(
      profileRepository: profileRepository,
      ref: ref,
      storageRepository: storageRepository);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _profileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController(
      {required UserProfileRepository profileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _profileRepository = profileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editProfile({
    File? profileFile,
    File? bannerFile,
    required BuildContext ctx,
    required String username,
  }) async {
    state = true;
    var user = _ref.read(userProvider)!;
    if (profileFile != null) {
      // communities/profile/community_id
      final res = await _storageRepository.storeFile(
        path: "users/profile",
        id: user.uid,
        file: profileFile,
      );

      res.fold((l) => showSnackBar(ctx, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }
    if (bannerFile != null) {
      // communities/banner/community_id
      final res = await _storageRepository.storeFile(
        path: "users/banner",
        id: user.uid,
        file: bannerFile,
      );

      res.fold((l) => showSnackBar(ctx, l.message),
          (r) => user = user.copyWith(banner: r));
    }

    user = user.copyWith(name: username);

    final res = await _profileRepository.editProfile(user);

    state = false;
    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      showSnackBar(ctx, "User profile updated!");
      Routemaster.of(ctx).pop();
    });
  }
}
