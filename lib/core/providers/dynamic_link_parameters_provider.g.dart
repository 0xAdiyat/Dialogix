// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_link/dynamic_link_parameters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dynamicLinkParametersHash() =>
    r'b242f210e482e8953d442b2a0f81c0040a0fa8f7';

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

/// See also [dynamicLinkParameters].
@ProviderFor(dynamicLinkParameters)
const dynamicLinkParametersProvider = DynamicLinkParametersFamily();

/// See also [dynamicLinkParameters].
class DynamicLinkParametersFamily extends Family<DynamicLinkParameters> {
  /// See also [dynamicLinkParameters].
  const DynamicLinkParametersFamily();

  /// See also [dynamicLinkParameters].
  DynamicLinkParametersProvider call({
    required List<DynamicLinkQuery> queries,
    String? path,
    String? postfixPath,
    String? title,
  }) {
    return DynamicLinkParametersProvider(
      queries: queries,
      path: path,
      postfixPath: postfixPath,
      title: title,
    );
  }

  @override
  DynamicLinkParametersProvider getProviderOverride(
    covariant DynamicLinkParametersProvider provider,
  ) {
    return call(
      queries: provider.queries,
      path: provider.path,
      postfixPath: provider.postfixPath,
      title: provider.title,
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
  String? get name => r'dynamicLinkParametersProvider';
}

/// See also [dynamicLinkParameters].
class DynamicLinkParametersProvider
    extends AutoDisposeProvider<DynamicLinkParameters> {
  /// See also [dynamicLinkParameters].
  DynamicLinkParametersProvider({
    required List<DynamicLinkQuery> queries,
    String? path,
    String? postfixPath,
    String? title,
  }) : this._internal(
          (ref) => dynamicLinkParameters(
            ref as DynamicLinkParametersRef,
            queries: queries,
            path: path,
            postfixPath: postfixPath,
            title: title,
          ),
          from: dynamicLinkParametersProvider,
          name: r'dynamicLinkParametersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dynamicLinkParametersHash,
          dependencies: DynamicLinkParametersFamily._dependencies,
          allTransitiveDependencies:
              DynamicLinkParametersFamily._allTransitiveDependencies,
          queries: queries,
          path: path,
          postfixPath: postfixPath,
          title: title,
        );

  DynamicLinkParametersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.queries,
    required this.path,
    required this.postfixPath,
    required this.title,
  }) : super.internal();

  final List<DynamicLinkQuery> queries;
  final String? path;
  final String? postfixPath;
  final String? title;

  @override
  Override overrideWith(
    DynamicLinkParameters Function(DynamicLinkParametersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DynamicLinkParametersProvider._internal(
        (ref) => create(ref as DynamicLinkParametersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        queries: queries,
        path: path,
        postfixPath: postfixPath,
        title: title,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<DynamicLinkParameters> createElement() {
    return _DynamicLinkParametersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DynamicLinkParametersProvider &&
        other.queries == queries &&
        other.path == path &&
        other.postfixPath == postfixPath &&
        other.title == title;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, queries.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);
    hash = _SystemHash.combine(hash, postfixPath.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DynamicLinkParametersRef
    on AutoDisposeProviderRef<DynamicLinkParameters> {
  /// The parameter `queries` of this provider.
  List<DynamicLinkQuery> get queries;

  /// The parameter `path` of this provider.
  String? get path;

  /// The parameter `postfixPath` of this provider.
  String? get postfixPath;

  /// The parameter `title` of this provider.
  String? get title;
}

class _DynamicLinkParametersProviderElement
    extends AutoDisposeProviderElement<DynamicLinkParameters>
    with DynamicLinkParametersRef {
  _DynamicLinkParametersProviderElement(super.provider);

  @override
  List<DynamicLinkQuery> get queries =>
      (origin as DynamicLinkParametersProvider).queries;
  @override
  String? get path => (origin as DynamicLinkParametersProvider).path;
  @override
  String? get postfixPath =>
      (origin as DynamicLinkParametersProvider).postfixPath;
  @override
  String? get title => (origin as DynamicLinkParametersProvider).title;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
