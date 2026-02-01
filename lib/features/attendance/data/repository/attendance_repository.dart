import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Attendance>> checkIn({
    required String employeeId,
    required LocationType locationType,
    required double lat,
    required double long,
  }) async {
    try {
      final result = await remoteDataSource.checkIn(
        employeeId,
        locationType,
        lat,
        long,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Attendance>> checkOut({
    required String attendanceId,
  }) async {
    try {
      final result = await remoteDataSource.checkOut(attendanceId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getMonthlyAttendance({
    required String employeeId,
    required int month,
    required int year,
  }) async {
    try {
      final result = await remoteDataSource.getMonthlyAttendance(
        employeeId,
        month,
        year,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Attendance?>> getTodayAttendance(
    String employeeId,
  ) async {
    try {
      final result = await remoteDataSource.getTodayAttendance(employeeId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
