import 'package:dialogix/core/failure.dart';
import 'package:dialogix/core/providers/dynamic_link_parameters_provider.dart';
import 'package:dialogix/core/providers/firebase_providers.dart';
import 'package:dialogix/core/type_defs.dart';
import 'package:dialogix/models/dynamic_link_query_model.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_dynamic_link_repository_provider.g.dart';


@riverpod
FirebaseDynamicLinkRepository firebaseDynamicLinkRepository(
        FirebaseDynamicLinkRepositoryRef ref,
        {required List<DynamicLinkQuery> queries,
         String? path, String? postfixPath}) =>
    FirebaseDynamicLinkRepository(
        parameters: ref
            .read(dynamicLinkParametersProvider(queries: queries, path: path, postfixPath: postfixPath)),
        dynamicLinks: ref.read(firebaseDynamicLinksProvider));

class FirebaseDynamicLinkRepository {
  final DynamicLinkParameters _parameters;
  final FirebaseDynamicLinks _dynamicLinks;

  FirebaseDynamicLinkRepository(
      {required DynamicLinkParameters parameters,
      required FirebaseDynamicLinks dynamicLinks})
      : _parameters = parameters,
        _dynamicLinks = dynamicLinks;

  FutureEither<String> createDynamicLink(bool short) async {
    String linkMessage;
    Uri url;
    try {
      if (short) {
        final ShortDynamicLink shortLink =
            await _dynamicLinks.buildShortLink(_parameters);
        url = shortLink.shortUrl;
      } else {
        url = await _dynamicLinks.buildLink(_parameters);
      }

      linkMessage = url.toString();

      return right(linkMessage);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
