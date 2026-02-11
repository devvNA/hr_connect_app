// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_map_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'a31928219ed6aae6c6585d63993df1438067530e';

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
