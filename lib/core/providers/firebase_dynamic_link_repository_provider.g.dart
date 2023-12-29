// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_link/firebase_dynamic_link_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseDynamicLinkHash() =>
    r'4c6a49c677184fdf41d10f1c29ff3b391f3fcd96';

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

/// See also [firebaseDynamicLink].
@ProviderFor(firebaseDynamicLink)
const firebaseDynamicLinkProvider = FirebaseDynamicLinkFamily();

/// See also [firebaseDynamicLink].
class FirebaseDynamicLinkFamily extends Family<FirebaseDynamicLinkRepository> {
  /// See also [firebaseDynamicLink].
  const FirebaseDynamicLinkFamily();

  /// See also [firebaseDynamicLink].
  FirebaseDynamicLinkProvider call({
    required DynamicLinkParameters parameters,
  }) {
    return FirebaseDynamicLinkProvider(
      parameters: parameters,
    );
  }

  @override
  FirebaseDynamicLinkProvider getProviderOverride(
    covariant FirebaseDynamicLinkProvider provider,
  ) {
    return call(
      parameters: provider.parameters,
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
  String? get name => r'firebaseDynamicLinkProvider';
}

/// See also [firebaseDynamicLink].
class FirebaseDynamicLinkProvider
    extends AutoDisposeProvider<FirebaseDynamicLinkRepository> {
  /// See also [firebaseDynamicLink].
  FirebaseDynamicLinkProvider({
    required DynamicLinkParameters parameters,
  }) : this._internal(
          (ref) => firebaseDynamicLink(
            ref as FirebaseDynamicLinkRef,
            parameters: parameters,
          ),
          from: firebaseDynamicLinkProvider,
          name: r'firebaseDynamicLinkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$firebaseDynamicLinkHash,
          dependencies: FirebaseDynamicLinkFamily._dependencies,
          allTransitiveDependencies:
              FirebaseDynamicLinkFamily._allTransitiveDependencies,
          parameters: parameters,
        );

  FirebaseDynamicLinkProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parameters,
  }) : super.internal();

  final DynamicLinkParameters parameters;

  @override
  Override overrideWith(
    FirebaseDynamicLinkRepository Function(FirebaseDynamicLinkRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FirebaseDynamicLinkProvider._internal(
        (ref) => create(ref as FirebaseDynamicLinkRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parameters: parameters,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<FirebaseDynamicLinkRepository> createElement() {
    return _FirebaseDynamicLinkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FirebaseDynamicLinkProvider &&
        other.parameters == parameters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parameters.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FirebaseDynamicLinkRef
    on AutoDisposeProviderRef<FirebaseDynamicLinkRepository> {
  /// The parameter `parameters` of this provider.
  DynamicLinkParameters get parameters;
}

class _FirebaseDynamicLinkProviderElement
    extends AutoDisposeProviderElement<FirebaseDynamicLinkRepository>
    with FirebaseDynamicLinkRef {
  _FirebaseDynamicLinkProviderElement(super.provider);

  @override
  DynamicLinkParameters get parameters =>
      (origin as FirebaseDynamicLinkProvider).parameters;
}

String _$firebaseDynamicLinkRepositoryHash() =>
    r'84ab7e6cdd560d184cf2d60648f9ac9670907a5c';

/// See also [firebaseDynamicLinkRepository].
@ProviderFor(firebaseDynamicLinkRepository)
final firebaseDynamicLinkRepositoryProvider =
    AutoDisposeProvider<FirebaseDynamicLinkRepository>.internal(
  firebaseDynamicLinkRepository,
  name: r'firebaseDynamicLinkRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseDynamicLinkRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseDynamicLinkRepositoryRef
    = AutoDisposeProviderRef<FirebaseDynamicLinkRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
