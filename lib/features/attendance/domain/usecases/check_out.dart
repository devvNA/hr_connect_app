import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class CheckOut {
  final AttendanceRepository repository;

  CheckOut(this.repository);

  Future<Either<Failure, Attendance>> call({required String attendanceId}) {
    return repository.checkOut(attendanceId: attendanceId);
  }
}
