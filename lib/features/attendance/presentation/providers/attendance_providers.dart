import 'dart:developer';

import 'package:hr_connect/features/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:hr_connect/features/attendance/data/repository/attendance_repository.dart';
import 'package:hr_connect/features/attendance/domain/entities/attendance.dart';
import 'package:hr_connect/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:hr_connect/features/attendance/domain/usecases/check_in.dart';
import 'package:hr_connect/features/attendance/domain/usecases/check_out.dart';
import 'package:hr_connect/features/attendance/domain/usecases/get_monthly_attendance.dart';
import 'package:hr_connect/features/attendance/domain/usecases/get_today_attendance.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_states.dart';
import 'package:hr_connect/features/attendance_map/presentation/providers/attendance_map_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'attendance_providers.g.dart';

// --- DATA LAYER PROVIDERS (keepAlive to prevent disposal during async ops) ---

@Riverpod(keepAlive: true)
AttendanceRemoteDataSource attendanceRemoteDataSource(Ref ref) {
  return AttendanceRemoteDataSourceImpl(Supabase.instance.client);
}

@Riverpod(keepAlive: true)
AttendanceRepository attendanceRepository(Ref ref) {
  return AttendanceRepositoryImpl(
    ref.watch(attendanceRemoteDataSourceProvider),
  );
}

// --- USE CASE PROVIDERS ---

@Riverpod(keepAlive: true)
CheckIn checkInUseCase(Ref ref) {
  return CheckIn(ref.watch(attendanceRepositoryProvider));
}

@Riverpod(keepAlive: true)
CheckOut checkOutUseCase(Ref ref) {
  return CheckOut(ref.watch(attendanceRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetTodayAttendance getTodayAttendanceUseCase(Ref ref) {
  return GetTodayAttendance(ref.watch(attendanceRepositoryProvider));
}

@Riverpod(keepAlive: true)
GetMonthlyAttendance getMonthlyAttendanceUseCase(Ref ref) {
  return GetMonthlyAttendance(ref.watch(attendanceRepositoryProvider));
}

// --- STATE NOTIFIER ---

@Riverpod(keepAlive: true)
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

    try {
      log('[Attendance] Loading data for user: ${user.id}');

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
        (failure) {
          log('[Attendance] Error loading today: ${failure.message}');
          state = AttendanceError(failure.message, source: 'init');
        },
        (todayAttendance) {
          log('[Attendance] Today attendance loaded: ${todayAttendance?.id}');
          monthlyResult.fold(
            (failure) {
              log('[Attendance] Error loading monthly: ${failure.message}');
              state = AttendanceError(failure.message, source: 'init');
            },
            (monthlyList) {
              log(
                '[Attendance] Monthly attendance count: ${monthlyList.length}',
              );
              state = AttendanceLoaded(
                todayAttendance: todayAttendance,
                monthlyAttendance: monthlyList,
              );
            },
          );
        },
      );
    } catch (e, stackTrace) {
      log('[Attendance] Exception: $e');
      log('[Attendance] StackTrace: $stackTrace');
      state = AttendanceError(e.toString(), source: 'init');
    }
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
    log('[Attendance] Check-in started for: $employeeId');
    log('[Attendance] Location: $lat, $long');
    state = AttendanceLoading();

    try {
      final officeResult = await ref
          .read(getActiveOfficeUseCaseProvider)
          .call();
      final office = officeResult.fold((failure) => null, (office) => office);
      if (office == null) {
        state = const AttendanceError(
          'Office location not loaded',
          source: 'checkIn',
        );
        return;
      }

      final result = await ref
          .read(checkInUseCaseProvider)
          .call(
            employeeId: employeeId,
            locationType: locationType,
            lat: lat,
            long: long,
            officeLat: office.latitude,
            officeLong: office.longitude,
            maxDistanceMeters: office.radiusMeters,
          );

      result.fold(
        (failure) {
          log('[Attendance] Check-in failed: ${failure.message}');
          state = AttendanceError(failure.message, source: 'checkIn');
        },
        (attendance) async {
          log('[Attendance] Check-in success: ${attendance.id}');
          // Reload all data after successful check-in
          await _loadInitialData();
        },
      );
    } catch (e, stackTrace) {
      log('[Attendance] Check-in exception: $e');
      log('[Attendance] StackTrace: $stackTrace');
      state = AttendanceError(e.toString(), source: 'checkIn');
    }
  }

  /// Check out from today's attendance
  Future<void> checkOut(String attendanceId) async {
    log('[Attendance] Check-out started for: $attendanceId');
    state = AttendanceLoading();

    try {
      final result = await ref
          .read(checkOutUseCaseProvider)
          .call(attendanceId: attendanceId);

      result.fold(
        (failure) {
          log('[Attendance] Check-out failed: ${failure.message}');
          state = AttendanceError(failure.message, source: 'checkOut');
        },
        (attendance) async {
          log('[Attendance] Check-out success: ${attendance.id}');
          // Reload all data after successful check-out
          await _loadInitialData();
        },
      );
    } catch (e, stackTrace) {
      log('[Attendance] Check-out exception: $e');
      log('[Attendance] StackTrace: $stackTrace');
      state = AttendanceError(e.toString(), source: 'checkOut');
    }
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
