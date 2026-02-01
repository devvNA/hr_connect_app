import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetMonthlyAttendance {
  final AttendanceRepository repository;

  GetMonthlyAttendance(this.repository);

  Future<Either<Failure, List<Attendance>>> call({
    required String employeeId,
    required int month,
    required int year,
  }) {
    return repository.getMonthlyAttendance(
      employeeId: employeeId,
      month: month,
      year: year,
    );
  }
}
