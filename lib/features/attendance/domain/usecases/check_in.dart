import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class CheckIn {
  final AttendanceRepository repository;

  CheckIn(this.repository);

  // Example: Office Location (Monas, Jakarta)
  static const double officeLat = -6.175258;
  static const double officeLong = 106.827008;
  static const double maxDistanceInMeters = 120;

  Future<Either<Failure, Attendance>> call({
    required String employeeId,
    required LocationType locationType,
    required double lat,
    required double long,
  }) async {
    // 1. Validate Location if WFO
    if (locationType == LocationType.wfo) {
      final distance = Geolocator.distanceBetween(
        officeLat,
        officeLong,
        lat,
        long,
      );

      if (distance > maxDistanceInMeters) {
        return Left(
          AttendanceFailure(
            'You are ${(distance - maxDistanceInMeters).toStringAsFixed(0)}m away from office. Please get closer.',
          ),
        );
      }
    }

    // 2. Proceed to Check In
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
