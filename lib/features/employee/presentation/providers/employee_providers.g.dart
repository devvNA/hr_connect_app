// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Remote data source provider

@ProviderFor(employeeRemoteDataSource)
final employeeRemoteDataSourceProvider = EmployeeRemoteDataSourceProvider._();

/// Remote data source provider

final class EmployeeRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          EmployeeRemoteDataSource,
          EmployeeRemoteDataSource,
          EmployeeRemoteDataSource
        >
    with $Provider<EmployeeRemoteDataSource> {
  /// Remote data source provider
  EmployeeRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<EmployeeRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRemoteDataSource create(Ref ref) {
    return employeeRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRemoteDataSource>(value),
    );
  }
}

String _$employeeRemoteDataSourceHash() =>
    r'7cbddfe9b31483fd28056eee5fb866add40fb8d6';

/// Repository provider

@ProviderFor(employeeRepository)
final employeeRepositoryProvider = EmployeeRepositoryProvider._();

/// Repository provider

final class EmployeeRepositoryProvider
    extends
        $FunctionalProvider<
          EmployeeRepository,
          EmployeeRepository,
          EmployeeRepository
        >
    with $Provider<EmployeeRepository> {
  /// Repository provider
  EmployeeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeRepositoryHash();

  @$internal
  @override
  $ProviderElement<EmployeeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EmployeeRepository create(Ref ref) {
    return employeeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeRepository>(value),
    );
  }
}

String _$employeeRepositoryHash() =>
    r'4f420f4a657c2c97620aa8411a06726a1adf8c78';

/// Department list notifier for filter chips

@ProviderFor(DepartmentListNotifier)
final departmentListProvider = DepartmentListNotifierProvider._();

/// Department list notifier for filter chips
final class DepartmentListNotifierProvider
    extends $NotifierProvider<DepartmentListNotifier, DepartmentListState> {
  /// Department list notifier for filter chips
  DepartmentListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentListNotifierHash();

  @$internal
  @override
  DepartmentListNotifier create() => DepartmentListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DepartmentListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DepartmentListState>(value),
    );
  }
}

String _$departmentListNotifierHash() =>
    r'6c9ea27c74d78b3ad081c318393d5e9ec3e99d7e';

/// Department list notifier for filter chips

abstract class _$DepartmentListNotifier extends $Notifier<DepartmentListState> {
  DepartmentListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DepartmentListState, DepartmentListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DepartmentListState, DepartmentListState>,
              DepartmentListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Employee list notifier

@ProviderFor(EmployeeListNotifier)
final employeeListProvider = EmployeeListNotifierProvider._();

/// Employee list notifier
final class EmployeeListNotifierProvider
    extends $NotifierProvider<EmployeeListNotifier, EmployeeListState> {
  /// Employee list notifier
  EmployeeListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeListNotifierHash();

  @$internal
  @override
  EmployeeListNotifier create() => EmployeeListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmployeeListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmployeeListState>(value),
    );
  }
}

String _$employeeListNotifierHash() =>
    r'ccf3ff1cad69ff466c37554567536718e557d6a3';

/// Employee list notifier

abstract class _$EmployeeListNotifier extends $Notifier<EmployeeListState> {
  EmployeeListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EmployeeListState, EmployeeListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmployeeListState, EmployeeListState>,
              EmployeeListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Helper provider: departments as list

@ProviderFor(departmentsData)
final departmentsDataProvider = DepartmentsDataProvider._();

/// Helper provider: departments as list

final class DepartmentsDataProvider
    extends
        $FunctionalProvider<
          List<DepartmentEntity>,
          List<DepartmentEntity>,
          List<DepartmentEntity>
        >
    with $Provider<List<DepartmentEntity>> {
  /// Helper provider: departments as list
  DepartmentsDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'departmentsDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$departmentsDataHash();

  @$internal
  @override
  $ProviderElement<List<DepartmentEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DepartmentEntity> create(Ref ref) {
    return departmentsData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DepartmentEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DepartmentEntity>>(value),
    );
  }
}

String _$departmentsDataHash() => r'9d694917bacec5db8292e0511be3dc87e1739a4e';

/// Helper provider: selected department ID

@ProviderFor(currentDepartmentId)
final currentDepartmentIdProvider = CurrentDepartmentIdProvider._();

/// Helper provider: selected department ID

final class CurrentDepartmentIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Helper provider: selected department ID
  CurrentDepartmentIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDepartmentIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDepartmentIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentDepartmentId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentDepartmentIdHash() =>
    r'f2aa9466fce8af438a1190908a21a1544121788b';

/// Helper provider: employees as list

@ProviderFor(employeesData)
final employeesDataProvider = EmployeesDataProvider._();

/// Helper provider: employees as list

final class EmployeesDataProvider
    extends
        $FunctionalProvider<
          List<EmployeeListEntity>,
          List<EmployeeListEntity>,
          List<EmployeeListEntity>
        >
    with $Provider<List<EmployeeListEntity>> {
  /// Helper provider: employees as list
  EmployeesDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeesDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeesDataHash();

  @$internal
  @override
  $ProviderElement<List<EmployeeListEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<EmployeeListEntity> create(Ref ref) {
    return employeesData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EmployeeListEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EmployeeListEntity>>(value),
    );
  }
}

String _$employeesDataHash() => r'6919951efe7dfac059df8c6420d958bf54f7a22a';

/// Helper provider: employee count

@ProviderFor(employeeCount)
final employeeCountProvider = EmployeeCountProvider._();

/// Helper provider: employee count

final class EmployeeCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Helper provider: employee count
  EmployeeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'employeeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$employeeCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return employeeCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$employeeCountHash() => r'079b9e330ecb82f7951f47a930fdb2857b8b7d17';
