import 'package:hr_connect/features/attendance/domain/entities/attendance.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:hr_connect/features/attendance_map/data/datasources/attendance_map_remote_datasource.dart';
import 'package:hr_connect/features/attendance_map/data/repositories/attendance_map_repository_impl.dart';
import 'package:hr_connect/features/attendance_map/domain/repositories/attendance_map_repository.dart';
import 'package:hr_connect/features/attendance_map/domain/usecases/calculate_distance.dart';
import 'package:hr_connect/features/attendance_map/domain/usecases/get_active_office.dart';
import 'package:hr_connect/features/attendance_map/domain/usecases/get_current_location.dart';
import 'package:hr_connect/features/attendance_map/presentation/providers/attendance_map_states.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'attendance_map_providers.g.dart';

// --- DATA LAYER PROVIDERS ---

@Riverpod(keepAlive: true)
AttendanceMapRemoteDatasource attendanceMapRemoteDatasource(Ref ref) {
  return AttendanceMapRemoteDatasourceImpl(Supabase.instance.client);
}

@Riverpod(keepAlive: true)
AttendanceMapRepository attendanceMapRepository(Ref ref) {
  return OfficeLocationRepositoryImpl(
    ref.watch(attendanceMapRemoteDatasourceProvider),
  );
}

// --- USE CASE PROVIDERS ---

@Riverpod(keepAlive: true)
GetActiveOffice getActiveOfficeUseCase(Ref ref) {
  return GetActiveOffice(ref.watch(attendanceMapRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetCurrentLocation getCurrentLocationUseCase(Ref ref) {
  return GetCurrentLocation();
}

@Riverpod(keepAlive: true)
CalculateDistance calculateDistanceUseCase(Ref ref) {
  return CalculateDistance();
}

// --- ATTENDANCE MAP NOTIFIER ---

@riverpod
class AttendanceMapNotifier extends _$AttendanceMapNotifier {
  @override
  AttendanceMapState build() {
    _initialize();
    return AttendanceMapLoading();
  }

  Future<void> _initialize() async {
    // 1. Fetch office location
    final officeResult =
        await ref.read(getActiveOfficeUseCaseProvider).call();

    final office = officeResult.fold(
      (failure) {
        state = AttendanceMapError(failure.message, source: 'office');
        return null;
      },
      (office) => office,
    );
    if (office == null) return;

    // 2. Get current user location
    final locationResult =
        await ref.read(getCurrentLocationUseCaseProvider).call();

    locationResult.fold(
      (failure) {
        state = AttendanceMapError(failure.message, source: 'location');
      },
      (position) {
        final latLng = LatLng(position.latitude, position.longitude);
        final distance = ref.read(calculateDistanceUseCaseProvider).call(
          fromLat: office.latitude,
          fromLng: office.longitude,
          toLat: position.latitude,
          toLng: position.longitude,
        );

        state = AttendanceMapLocated(
          currentLocation: latLng,
          isWithinRadius: distance <= office.radiusMeters,
          distanceToOffice: distance,
          office: office,
        );
      },
    );
  }

  Future<void> refreshLocation() async {
    state = AttendanceMapLoading();
    await _initialize();
  }

  Future<void> confirmCheckIn() async {
    final current = state;
    if (current is! AttendanceMapLocated || current.isProcessing) return;

    state = current.copyWith(isProcessing: true);

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      state = const AttendanceMapError(
        'User not authenticated',
        source: 'confirm',
      );
      return;
    }

    await ref
        .read(attendanceProvider.notifier)
        .checkIn(
          employeeId: userId,
          locationType: LocationType.wfo,
          lat: current.currentLocation.latitude,
          long: current.currentLocation.longitude,
        );

    state = AttendanceMapSuccess();
  }

  Future<void> confirmCheckOut(String attendanceId) async {
    final current = state;
    if (current is! AttendanceMapLocated || current.isProcessing) return;

    state = current.copyWith(isProcessing: true);

    await ref.read(attendanceProvider.notifier).checkOut(attendanceId);

    state = AttendanceMapSuccess();
  }
}
