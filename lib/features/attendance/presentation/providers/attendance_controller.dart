import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/attendance_remote_datasource.dart';
import '../../data/repository/attendance_repository.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/usecases/check_in.dart';
import '../../domain/usecases/check_out.dart';
import '../../domain/usecases/get_monthly_attendance.dart';
import '../../domain/usecases/get_today_attendance.dart';

// --- DATA LAYER PROVIDERS ---

final attendanceRemoteDataSourceProvider = Provider<AttendanceRemoteDataSource>(
  (ref) {
    return AttendanceRemoteDataSourceImpl(Supabase.instance.client);
  },
);

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl(
    ref.watch(attendanceRemoteDataSourceProvider),
  );
});

// --- USE CASE PROVIDERS ---

final checkInUseCaseProvider = Provider<CheckIn>((ref) {
  return CheckIn(ref.watch(attendanceRepositoryProvider));
});

final checkOutUseCaseProvider = Provider<CheckOut>((ref) {
  return CheckOut(ref.watch(attendanceRepositoryProvider));
});

final getTodayAttendanceUseCaseProvider = Provider<GetTodayAttendance>((ref) {
  return GetTodayAttendance(ref.watch(attendanceRepositoryProvider));
});

final getMonthlyAttendanceUseCaseProvider = Provider<GetMonthlyAttendance>((
  ref,
) {
  return GetMonthlyAttendance(ref.watch(attendanceRepositoryProvider));
});

// --- STATE PROVIDERS ---

// 1. Controller for Side Effects (Check In / Check Out) - AsyncNotifier for simple state
class AttendanceController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial state to build
  }

  Future<void> checkIn({
    required String employeeId,
    required LocationType locationType,
    required double lat,
    required double long,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(checkInUseCaseProvider);
    final result = await useCase(
      employeeId: employeeId,
      locationType: locationType,
      lat: lat,
      long: long,
    );

    result.fold(
      (failure) => state = AsyncError(
        failure.message,
        StackTrace.current,
      ), // Assuming Failure has message
      (success) {
        state = const AsyncData(null);
        ref.invalidate(todayAttendanceProvider); // Refresh today's attendance
        ref.invalidate(monthlyAttendanceProvider); // Refresh monthly list
      },
    );
  }

  Future<void> checkOut(String attendanceId) async {
    state = const AsyncLoading();
    final useCase = ref.read(checkOutUseCaseProvider);
    final result = await useCase(attendanceId: attendanceId);

    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (success) {
        state = const AsyncData(null);
        ref.invalidate(todayAttendanceProvider);
        ref.invalidate(monthlyAttendanceProvider);
      },
    );
  }
}

final attendanceControllerProvider =
    AsyncNotifierProvider<AttendanceController, void>(() {
      return AttendanceController();
    });

// 2. Fetch Today's Attendance
final todayAttendanceProvider = FutureProvider.autoDispose<Attendance?>((
  ref,
) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) throw Exception('User not logged in');

  final useCase = ref.watch(getTodayAttendanceUseCaseProvider);
  final result = await useCase(user.id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (attendance) => attendance,
  );
});

// 3. Fetch Monthly Attendance
final monthlyAttendanceProvider = FutureProvider.family
    .autoDispose<List<Attendance>, DateTime>((ref, date) async {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final useCase = ref.watch(getMonthlyAttendanceUseCaseProvider);
      final result = await useCase(
        employeeId: user.id,
        month: date.month,
        year: date.year,
      );

      return result.fold(
        (failure) => throw Exception(failure.message),
        (list) => list,
      );
    });
