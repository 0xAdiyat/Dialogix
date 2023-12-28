// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_dynamic_link_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseDynamicLinkRepositoryHash() =>
    r'0d91b2a2613408fc8e3f407d027bedfdc518e051';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [firebaseDynamicLinkRepository].
@ProviderFor(firebaseDynamicLinkRepository)
const firebaseDynamicLinkRepositoryProvider =
    FirebaseDynamicLinkRepositoryFamily();

/// See also [firebaseDynamicLinkRepository].
class FirebaseDynamicLinkRepositoryFamily
    extends Family<FirebaseDynamicLinkRepository> {
  /// See also [firebaseDynamicLinkRepository].
  const FirebaseDynamicLinkRepositoryFamily();

  /// See also [firebaseDynamicLinkRepository].
  FirebaseDynamicLinkRepositoryProvider call({
    required List<DynamicLinkQuery> queries,
    String? path,
    String? postfixPath,
  }) {
    return FirebaseDynamicLinkRepositoryProvider(
      queries: queries,
      path: path,
      postfixPath: postfixPath,
    );
  }

  @override
  FirebaseDynamicLinkRepositoryProvider getProviderOverride(
    covariant FirebaseDynamicLinkRepositoryProvider provider,
  ) {
    return call(
      queries: provider.queries,
      path: provider.path,
      postfixPath: provider.postfixPath,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'firebaseDynamicLinkRepositoryProvider';
}

/// See also [firebaseDynamicLinkRepository].
class FirebaseDynamicLinkRepositoryProvider
    extends AutoDisposeProvider<FirebaseDynamicLinkRepository> {
  /// See also [firebaseDynamicLinkRepository].
  FirebaseDynamicLinkRepositoryProvider({
    required List<DynamicLinkQuery> queries,
    String? path,
    String? postfixPath,
  }) : this._internal(
          (ref) => firebaseDynamicLinkRepository(
            ref as FirebaseDynamicLinkRepositoryRef,
            queries: queries,
            path: path,
            postfixPath: postfixPath,
          ),
          from: firebaseDynamicLinkRepositoryProvider,
          name: r'firebaseDynamicLinkRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$firebaseDynamicLinkRepositoryHash,
          dependencies: FirebaseDynamicLinkRepositoryFamily._dependencies,
          allTransitiveDependencies:
              FirebaseDynamicLinkRepositoryFamily._allTransitiveDependencies,
          queries: queries,
          path: path,
          postfixPath: postfixPath,
        );

  FirebaseDynamicLinkRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.queries,
    required this.path,
    required this.postfixPath,
  }) : super.internal();

  final List<DynamicLinkQuery> queries;
  final String? path;
  final String? postfixPath;

  @override
  Override overrideWith(
    FirebaseDynamicLinkRepository Function(
            FirebaseDynamicLinkRepositoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FirebaseDynamicLinkRepositoryProvider._internal(
        (ref) => create(ref as FirebaseDynamicLinkRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        queries: queries,
        path: path,
        postfixPath: postfixPath,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<FirebaseDynamicLinkRepository> createElement() {
    return _FirebaseDynamicLinkRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FirebaseDynamicLinkRepositoryProvider &&
        other.queries == queries &&
        other.path == path &&
        other.postfixPath == postfixPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, queries.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);
    hash = _SystemHash.combine(hash, postfixPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FirebaseDynamicLinkRepositoryRef
    on AutoDisposeProviderRef<FirebaseDynamicLinkRepository> {
  /// The parameter `queries` of this provider.
  List<DynamicLinkQuery> get queries;

  /// The parameter `path` of this provider.
  String? get path;

  /// The parameter `postfixPath` of this provider.
  String? get postfixPath;
}

class _FirebaseDynamicLinkRepositoryProviderElement
    extends AutoDisposeProviderElement<FirebaseDynamicLinkRepository>
    with FirebaseDynamicLinkRepositoryRef {
  _FirebaseDynamicLinkRepositoryProviderElement(super.provider);

  @override
  List<DynamicLinkQuery> get queries =>
      (origin as FirebaseDynamicLinkRepositoryProvider).queries;
  @override
  String? get path => (origin as FirebaseDynamicLinkRepositoryProvider).path;
  @override
  String? get postfixPath =>
      (origin as FirebaseDynamicLinkRepositoryProvider).postfixPath;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
