// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(attendanceMapRemoteDatasource)
final attendanceMapRemoteDatasourceProvider =
    AttendanceMapRemoteDatasourceProvider._();

final class AttendanceMapRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          AttendanceMapRemoteDatasource,
          AttendanceMapRemoteDatasource,
          AttendanceMapRemoteDatasource
        >
    with $Provider<AttendanceMapRemoteDatasource> {
  AttendanceMapRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceMapRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceMapRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<AttendanceMapRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceMapRemoteDatasource create(Ref ref) {
    return attendanceMapRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceMapRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceMapRemoteDatasource>(
        value,
      ),
    );
  }
}

String _$attendanceMapRemoteDatasourceHash() =>
    r'a21cd399db0fedae651b17c65a019ae49c316b11';

@ProviderFor(attendanceMapRepository)
final attendanceMapRepositoryProvider = AttendanceMapRepositoryProvider._();

final class AttendanceMapRepositoryProvider
    extends
        $FunctionalProvider<
          AttendanceMapRepository,
          AttendanceMapRepository,
          AttendanceMapRepository
        >
    with $Provider<AttendanceMapRepository> {
  AttendanceMapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceMapRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceMapRepositoryHash();

  @$internal
  @override
  $ProviderElement<AttendanceMapRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceMapRepository create(Ref ref) {
    return attendanceMapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceMapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceMapRepository>(value),
    );
  }
}

String _$attendanceMapRepositoryHash() =>
    r'dfb516a342615a2f9a9888a7c384fc0790ecd36f';

@ProviderFor(getActiveOfficeUseCase)
final getActiveOfficeUseCaseProvider = GetActiveOfficeUseCaseProvider._();

final class GetActiveOfficeUseCaseProvider
    extends
        $FunctionalProvider<GetActiveOffice, GetActiveOffice, GetActiveOffice>
    with $Provider<GetActiveOffice> {
  GetActiveOfficeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getActiveOfficeUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getActiveOfficeUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetActiveOffice> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetActiveOffice create(Ref ref) {
    return getActiveOfficeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetActiveOffice value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetActiveOffice>(value),
    );
  }
}

String _$getActiveOfficeUseCaseHash() =>
    r'49fa75db5de3a890b16f519e73802a9459d224f6';

@ProviderFor(getCurrentLocationUseCase)
final getCurrentLocationUseCaseProvider = GetCurrentLocationUseCaseProvider._();

final class GetCurrentLocationUseCaseProvider
    extends
        $FunctionalProvider<
          GetCurrentLocation,
          GetCurrentLocation,
          GetCurrentLocation
        >
    with $Provider<GetCurrentLocation> {
  GetCurrentLocationUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentLocationUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentLocationUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentLocation> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCurrentLocation create(Ref ref) {
    return getCurrentLocationUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentLocation value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentLocation>(value),
    );
  }
}

String _$getCurrentLocationUseCaseHash() =>
    r'1f269106be89040aa4d60f9bbee98f099745a8a6';

@ProviderFor(calculateDistanceUseCase)
final calculateDistanceUseCaseProvider = CalculateDistanceUseCaseProvider._();

final class CalculateDistanceUseCaseProvider
    extends
        $FunctionalProvider<
          CalculateDistance,
          CalculateDistance,
          CalculateDistance
        >
    with $Provider<CalculateDistance> {
  CalculateDistanceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calculateDistanceUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calculateDistanceUseCaseHash();

  @$internal
  @override
  $ProviderElement<CalculateDistance> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CalculateDistance create(Ref ref) {
    return calculateDistanceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalculateDistance value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalculateDistance>(value),
    );
  }
}

String _$calculateDistanceUseCaseHash() =>
    r'fb6a5befa70a7be27a0bbe1bd1b9fe334cc206e8';

@ProviderFor(AttendanceMapNotifier)
final attendanceMapProvider = AttendanceMapNotifierProvider._();

final class AttendanceMapNotifierProvider
    extends $NotifierProvider<AttendanceMapNotifier, AttendanceMapState> {
  AttendanceMapNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceMapNotifierHash();

  @$internal
  @override
  AttendanceMapNotifier create() => AttendanceMapNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceMapState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceMapState>(value),
    );
  }
}

String _$attendanceMapNotifierHash() =>
    r'a9f7fe1ff5c8cef4128669edeb331ad38586b49c';

abstract class _$AttendanceMapNotifier extends $Notifier<AttendanceMapState> {
  AttendanceMapState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AttendanceMapState, AttendanceMapState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AttendanceMapState, AttendanceMapState>,
              AttendanceMapState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
