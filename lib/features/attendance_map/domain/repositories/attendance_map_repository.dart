import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance_map/domain/entities/attendance_map_entity.dart';

abstract class AttendanceMapRepository {
  Future<Either<Failure, AttendanceMapEntity>> getActiveOffice();
}
