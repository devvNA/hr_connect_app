import 'package:hr_connect/features/attendance/domain/entities/attendance.dart';

/// Sealed class for Attendance states
sealed class AttendanceState {
  const AttendanceState();
}

/// Initial state before any action
class AttendanceInitial extends AttendanceState {}

/// Loading state during async operations
class AttendanceLoading extends AttendanceState {}

/// State when attendance data is successfully loaded
class AttendanceLoaded extends AttendanceState {
  final Attendance? todayAttendance;
  final List<Attendance> monthlyAttendance;

  const AttendanceLoaded({
    this.todayAttendance,
    this.monthlyAttendance = const [],
  });

  AttendanceLoaded copyWith({
    Attendance? todayAttendance,
    List<Attendance>? monthlyAttendance,
  }) {
    return AttendanceLoaded(
      todayAttendance: todayAttendance ?? this.todayAttendance,
      monthlyAttendance: monthlyAttendance ?? this.monthlyAttendance,
    );
  }
}

/// State for successful check-in/check-out action
class AttendanceActionSuccess extends AttendanceState {
  final String message;
  const AttendanceActionSuccess(this.message);
}

/// Error state with message and optional source
class AttendanceError extends AttendanceState {
  final String message;
  final String? source;
  const AttendanceError(this.message, {this.source});
}
