import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/dynamic_link_query_model.dart';

part '../dynamic_link_parameters_provider.g.dart';

@riverpod
DynamicLinkParameters dynamicLinkParameters(DynamicLinkParametersRef ref,
    {required List<DynamicLinkQuery> queries,
    String? path,
    String? postfixPath, String? title}) {
  // Map each query to a query parameter
  final queryParameters = queries
      .map((query) =>
          "${query.key}=${Uri.encodeComponent(query.value.toString())}")
      .join("&");

  final prePath =
      "https://dialogix.page.link${path != null ? '/${Uri.encodeComponent(path)}' : ''}";
  final postPath =
      postfixPath != null ? "/${Uri.encodeComponent(postfixPath)}" : '';

  return DynamicLinkParameters(
    uriPrefix: 'https://dialogix.page.link',
    socialMetaTagParameters: SocialMetaTagParameters(title: title),
    link: Uri.parse("$prePath/$queryParameters$postPath"),
    androidParameters: const AndroidParameters(
      packageName: 'com.anon007.dialogix',
      minimumVersion: 0,
    ),
    iosParameters: const IOSParameters(
      bundleId: 'com.anon007.dialogix',
      minimumVersion: '0',
    ),
  );
}
