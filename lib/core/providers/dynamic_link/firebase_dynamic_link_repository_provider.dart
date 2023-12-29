import 'dart:async';

import 'package:dialogix/core/failure.dart';
import 'package:dialogix/core/providers/firebase_providers.dart';
import 'package:dialogix/core/type_defs.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../firebase_dynamic_link_repository_provider.g.dart';

@riverpod
FirebaseDynamicLinkRepository firebaseDynamicLink(FirebaseDynamicLinkRef ref,
        {required DynamicLinkParameters parameters}) =>
    FirebaseDynamicLinkRepository(
        parameters: parameters,
        dynamicLinks: ref.read(firebaseDynamicLinksProvider));

@Riverpod(keepAlive: true)
FirebaseDynamicLinkRepository firebaseDynamicLinkRepository(
  FirebaseDynamicLinkRepositoryRef ref,
) =>
    FirebaseDynamicLinkRepository(
        dynamicLinks: ref.read(firebaseDynamicLinksProvider));

class FirebaseDynamicLinkRepository {
  final DynamicLinkParameters? _parameters;
  final FirebaseDynamicLinks _dynamicLinks;

  FirebaseDynamicLinkRepository(
      {DynamicLinkParameters? parameters,
      required FirebaseDynamicLinks dynamicLinks})
      : _parameters = parameters,
        _dynamicLinks = dynamicLinks;

  FutureEither<String> createDynamicLink(bool short) async {
    String linkMessage;
    Uri url;
    try {
      if (short) {
        final ShortDynamicLink shortLink = await _dynamicLinks.buildShortLink(
          _parameters!,
          shortLinkType: ShortDynamicLinkType.unguessable,
        );

        url = shortLink.shortUrl;
      } else {
        url = await _dynamicLinks.buildLink(_parameters!);
      }

      linkMessage = url.toString();

      return right(linkMessage);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<Uri> initDynamicLink() async {
    try {
      final PendingDynamicLinkData? data = await _dynamicLinks.getInitialLink();
      if (data != null) {
        final Uri deepLink = data.link;
        return right(deepLink);
      }

      final Completer<NotFutureEither<Uri>> completer =
          Completer<NotFutureEither<Uri>>();
      _dynamicLinks.onLink.listen(
        (pendingDynamicLinkData) {
          final Uri deepLink = pendingDynamicLinkData.link;
          completer.complete(right(deepLink));
        },
        onError: (error) {
          completer.complete(left(Failure(error)));
        },
        cancelOnError: true,
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(left(Failure('No deep link found')));
          }
        },
      );

      return await completer.future;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }
}
