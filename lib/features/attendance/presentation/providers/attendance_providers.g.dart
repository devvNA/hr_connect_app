// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(attendanceRemoteDataSource)
final attendanceRemoteDataSourceProvider =
    AttendanceRemoteDataSourceProvider._();

final class AttendanceRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AttendanceRemoteDataSource,
          AttendanceRemoteDataSource,
          AttendanceRemoteDataSource
        >
    with $Provider<AttendanceRemoteDataSource> {
  AttendanceRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AttendanceRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceRemoteDataSource create(Ref ref) {
    return attendanceRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceRemoteDataSource>(value),
    );
  }
}

String _$attendanceRemoteDataSourceHash() =>
    r'5ac20329f69ede868415040f57ea0c839275a231';

@ProviderFor(attendanceRepository)
final attendanceRepositoryProvider = AttendanceRepositoryProvider._();

final class AttendanceRepositoryProvider
    extends
        $FunctionalProvider<
          AttendanceRepository,
          AttendanceRepository,
          AttendanceRepository
        >
    with $Provider<AttendanceRepository> {
  AttendanceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceRepositoryHash();

  @$internal
  @override
  $ProviderElement<AttendanceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AttendanceRepository create(Ref ref) {
    return attendanceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceRepository>(value),
    );
  }
}

String _$attendanceRepositoryHash() =>
    r'e89142730dad6d75c97afa6a5d185c777cf1275a';

@ProviderFor(checkInUseCase)
final checkInUseCaseProvider = CheckInUseCaseProvider._();

final class CheckInUseCaseProvider
    extends $FunctionalProvider<CheckIn, CheckIn, CheckIn>
    with $Provider<CheckIn> {
  CheckInUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkInUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkInUseCaseHash();

  @$internal
  @override
  $ProviderElement<CheckIn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CheckIn create(Ref ref) {
    return checkInUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckIn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckIn>(value),
    );
  }
}

String _$checkInUseCaseHash() => r'4c79d9605cb5b970b00e1a3a2a94892120813690';

@ProviderFor(checkOutUseCase)
final checkOutUseCaseProvider = CheckOutUseCaseProvider._();

final class CheckOutUseCaseProvider
    extends $FunctionalProvider<CheckOut, CheckOut, CheckOut>
    with $Provider<CheckOut> {
  CheckOutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkOutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkOutUseCaseHash();

  @$internal
  @override
  $ProviderElement<CheckOut> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CheckOut create(Ref ref) {
    return checkOutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckOut value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckOut>(value),
    );
  }
}

String _$checkOutUseCaseHash() => r'4eb676ea2fcc3df3bce178da653f4a01f4ee7e91';

@ProviderFor(getTodayAttendanceUseCase)
final getTodayAttendanceUseCaseProvider = GetTodayAttendanceUseCaseProvider._();

final class GetTodayAttendanceUseCaseProvider
    extends
        $FunctionalProvider<
          GetTodayAttendance,
          GetTodayAttendance,
          GetTodayAttendance
        >
    with $Provider<GetTodayAttendance> {
  GetTodayAttendanceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTodayAttendanceUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTodayAttendanceUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTodayAttendance> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetTodayAttendance create(Ref ref) {
    return getTodayAttendanceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTodayAttendance value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTodayAttendance>(value),
    );
  }
}

String _$getTodayAttendanceUseCaseHash() =>
    r'b92d45ba7b00c9fee68defda83b4745064db35db';

@ProviderFor(getMonthlyAttendanceUseCase)
final getMonthlyAttendanceUseCaseProvider =
    GetMonthlyAttendanceUseCaseProvider._();

final class GetMonthlyAttendanceUseCaseProvider
    extends
        $FunctionalProvider<
          GetMonthlyAttendance,
          GetMonthlyAttendance,
          GetMonthlyAttendance
        >
    with $Provider<GetMonthlyAttendance> {
  GetMonthlyAttendanceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMonthlyAttendanceUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMonthlyAttendanceUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetMonthlyAttendance> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetMonthlyAttendance create(Ref ref) {
    return getMonthlyAttendanceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMonthlyAttendance value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMonthlyAttendance>(value),
    );
  }
}

String _$getMonthlyAttendanceUseCaseHash() =>
    r'7a46bfcb5f95ec27665238ab1dcf354afa84674a';

@ProviderFor(AttendanceNotifier)
final attendanceProvider = AttendanceNotifierProvider._();

final class AttendanceNotifierProvider
    extends $NotifierProvider<AttendanceNotifier, AttendanceState> {
  AttendanceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceNotifierHash();

  @$internal
  @override
  AttendanceNotifier create() => AttendanceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AttendanceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AttendanceState>(value),
    );
  }
}

String _$attendanceNotifierHash() =>
    r'1af0f9b441e5c84277fa563327c8ff7c62019fae';

abstract class _$AttendanceNotifier extends $Notifier<AttendanceState> {
  AttendanceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AttendanceState, AttendanceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AttendanceState, AttendanceState>,
              AttendanceState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
