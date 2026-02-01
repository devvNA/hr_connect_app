import 'package:hr_connect/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:hr_connect/features/attendance/data/repository/attendance_repository.dart';
import 'package:hr_connect/features/attendance/domain/entities/attendance.dart';
import 'package:hr_connect/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:hr_connect/features/attendance/domain/usecases/check_in.dart';
import 'package:hr_connect/features/attendance/domain/usecases/check_out.dart';
import 'package:hr_connect/features/attendance/domain/usecases/get_monthly_attendance.dart';
import 'package:hr_connect/features/attendance/domain/usecases/get_today_attendance.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_states.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'attendance_providers.g.dart';

// --- DATA LAYER PROVIDERS ---

@riverpod
AttendanceRemoteDataSource attendanceRemoteDataSource(Ref ref) {
  return AttendanceRemoteDataSourceImpl(Supabase.instance.client);
}

@riverpod
AttendanceRepository attendanceRepository(Ref ref) {
  return AttendanceRepositoryImpl(
    ref.watch(attendanceRemoteDataSourceProvider),
  );
}

// --- USE CASE PROVIDERS ---

@riverpod
CheckIn checkInUseCase(Ref ref) {
  return CheckIn(ref.watch(attendanceRepositoryProvider));
}

@riverpod
CheckOut checkOutUseCase(Ref ref) {
  return CheckOut(ref.watch(attendanceRepositoryProvider));
}

@riverpod
GetTodayAttendance getTodayAttendanceUseCase(Ref ref) {
  return GetTodayAttendance(ref.watch(attendanceRepositoryProvider));
}

@riverpod
GetMonthlyAttendance getMonthlyAttendanceUseCase(Ref ref) {
  return GetMonthlyAttendance(ref.watch(attendanceRepositoryProvider));
}

// --- STATE NOTIFIER ---

@riverpod
class AttendanceNotifier extends _$AttendanceNotifier {
  @override
  AttendanceState build() {
    // Load initial data on build
    _loadInitialData();
    return AttendanceLoading();
  }

  /// Load today's attendance and monthly data on initialization
  Future<void> _loadInitialData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      state = const AttendanceError('User not logged in', source: 'init');
      return;
    }

    // Fetch today's attendance
    final todayResult = await ref
        .read(getTodayAttendanceUseCaseProvider)
        .call(user.id);
    final now = DateTime.now();
    final monthlyResult = await ref
        .read(getMonthlyAttendanceUseCaseProvider)
        .call(employeeId: user.id, month: now.month, year: now.year);

    // Combine results
    todayResult.fold(
      (failure) => state = AttendanceError(failure.message, source: 'init'),
      (todayAttendance) {
        monthlyResult.fold(
          (failure) => state = AttendanceError(failure.message, source: 'init'),
          (monthlyList) => state = AttendanceLoaded(
            todayAttendance: todayAttendance,
            monthlyAttendance: monthlyList,
          ),
        );
      },
    );
  }

  /// Refresh all attendance data
  Future<void> refresh() async {
    state = AttendanceLoading();
    await _loadInitialData();
  }

  /// Check in for today
  Future<void> checkIn({
    required String employeeId,
    required LocationType locationType,
    required double lat,
    required double long,
  }) async {
    state = AttendanceLoading();

    final result = await ref
        .read(checkInUseCaseProvider)
        .call(
          employeeId: employeeId,
          locationType: locationType,
          lat: lat,
          long: long,
        );

    result.fold(
      (failure) => state = AttendanceError(failure.message, source: 'checkIn'),
      (attendance) async {
        // Reload all data after successful check-in
        await _loadInitialData();
      },
    );
  }

  /// Check out from today's attendance
  Future<void> checkOut(String attendanceId) async {
    state = AttendanceLoading();

    final result = await ref
        .read(checkOutUseCaseProvider)
        .call(attendanceId: attendanceId);

    result.fold(
      (failure) => state = AttendanceError(failure.message, source: 'checkOut'),
      (attendance) async {
        // Reload all data after successful check-out
        await _loadInitialData();
      },
    );
  }

  /// Load attendance for a specific month
  Future<void> loadMonthlyAttendance({
    required int month,
    required int year,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      state = const AttendanceError('User not logged in', source: 'monthly');
      return;
    }

    // Keep current state while loading
    final currentState = state;

    final result = await ref
        .read(getMonthlyAttendanceUseCaseProvider)
        .call(employeeId: user.id, month: month, year: year);

    result.fold(
      (failure) => state = AttendanceError(failure.message, source: 'monthly'),
      (monthlyList) {
        if (currentState is AttendanceLoaded) {
          state = currentState.copyWith(monthlyAttendance: monthlyList);
        } else {
          state = AttendanceLoaded(monthlyAttendance: monthlyList);
        }
      },
    );
  }

  /// Clear error state
  void clearError() {
    if (state is AttendanceError) {
      state = AttendanceInitial();
    }
  }
}
