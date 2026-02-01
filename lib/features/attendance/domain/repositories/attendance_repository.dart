import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, Attendance>> checkIn({
    required String employeeId,
    required LocationType locationType,
    required double lat,
    required double long,
  });

  Future<Either<Failure, Attendance>> checkOut({required String attendanceId});

  Future<Either<Failure, Attendance?>> getTodayAttendance(String employeeId);

  Future<Either<Failure, List<Attendance>>> getMonthlyAttendance({
    required String employeeId,
    required int month,
    required int year,
  });
}
