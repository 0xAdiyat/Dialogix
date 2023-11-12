import 'dart:io';

import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/community/repository/community_repository.dart';
import 'package:dialogix/models/community_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';

final getCommunityByNameProvider =
    StreamProvider.family<CommunityModel, String>((ref, String name) {
  final communityController = ref.read(communityControllerProvider.notifier);
  return communityController.getCommunityByName(name);
});
final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository,
      ref: ref,
      storageRepository: storageRepository);
});
final userCommunitiesProvider = StreamProvider<List<CommunityModel>>((ref) {
  final communityController = ref.watch(communityControllerProvider
      .notifier); // bcz communityControllerProvider is a stateNotifier that's why here dot notifier is required
  return communityController.getUserCommunities();
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Stream<List<CommunityModel>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) =>
      _communityRepository.getCommunityByName(name.toLowerCase());
  void editCommunity(
      {required CommunityModel community,
      File? profileFile,
      File? bannerFile,
      required BuildContext ctx}) async {
    state = true;
    if (profileFile != null) {
      // communities/profile/community_id
      final res = await _storageRepository.storeFile(
        path: "communities/profile",
        id: community.id,
        file: profileFile,
      );

      res.fold((l) => showSnackBar(ctx, l.message),
          (r) => community = community.copyWith(avatar: r));
    }
    if (bannerFile != null) {
      // communities/banner/community_id
      final res = await _storageRepository.storeFile(
        path: "communities/banner",
        id: community.id,
        file: bannerFile,
      );

      res.fold((l) => showSnackBar(ctx, l.message),
          (r) => community = community.copyWith(banner: r));
    }

    final res = await _communityRepository.editCommunity(community);

    state = false;
    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      showSnackBar(ctx, "Community profile updated!");
      Routemaster.of(ctx).pop();
    });
  }

  void createCommunity(BuildContext ctx, String name) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    final community = CommunityModel(
        id: name.toLowerCase(),
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      Routemaster.of(ctx).pop();
      showSnackBar(ctx, "Community created successfully!");
    });
  }
}
