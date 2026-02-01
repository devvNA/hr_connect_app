import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetTodayAttendance {
  final AttendanceRepository repository;

  GetTodayAttendance(this.repository);

  Future<Either<Failure, Attendance?>> call(String employeeId) {
    return repository.getTodayAttendance(employeeId);
  }
}
