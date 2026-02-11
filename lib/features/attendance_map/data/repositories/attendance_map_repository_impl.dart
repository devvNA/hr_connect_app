import 'package:dartz/dartz.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/attendance_map/data/datasources/attendance_map_remote_datasource.dart';
import 'package:hr_connect/features/attendance_map/domain/entities/attendance_map_entity.dart';
import 'package:hr_connect/features/attendance_map/domain/repositories/attendance_map_repository.dart';

class OfficeLocationRepositoryImpl implements AttendanceMapRepository {
  final AttendanceMapRemoteDatasource remoteDataSource;

  OfficeLocationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AttendanceMapEntity>> getActiveOffice() {
    return remoteDataSource.getActiveOffice();
  }
}
