import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance_map_entity.dart';
import '../repositories/attendance_map_repository.dart';

class GetActiveOffice {
  final AttendanceMapRepository repository;

  GetActiveOffice(this.repository);

  Future<Either<Failure, AttendanceMapEntity>> call() {
    return repository.getActiveOffice();
  }
}
