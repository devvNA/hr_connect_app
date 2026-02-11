import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class CheckIn {
  final AttendanceRepository repository;

  CheckIn(this.repository);

  Future<Either<Failure, Attendance>> call({
    required String employeeId,
    required LocationType locationType,
    required double lat,
    required double long,
    required double officeLat,
    required double officeLong,
    required double maxDistanceMeters,
  }) async {
    if (locationType == LocationType.wfo) {
      final distance = Geolocator.distanceBetween(
        officeLat,
        officeLong,
        lat,
        long,
      );

      if (distance > maxDistanceMeters) {
        return Left(
          AttendanceFailure(
            'You are ${(distance - maxDistanceMeters).toStringAsFixed(0)}m away from office. Please get closer.',
          ),
        );
      }
    }

    return repository.checkIn(
      employeeId: employeeId,
      locationType: locationType,
      lat: lat,
      long: long,
    );
  }
}

class AttendanceFailure extends Failure {
  const AttendanceFailure(super.message);
}
