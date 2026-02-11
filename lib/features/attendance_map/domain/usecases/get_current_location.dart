import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/error/failures.dart';

class GetCurrentLocation {
  Future<Either<Failure, Position>> call() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(
          LocationFailure('Location services are disabled. Please enable GPS.'),
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(
            LocationFailure('Location permissions are denied.'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
          LocationFailure(
            'Location permissions are permanently denied. Please enable in settings.',
          ),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return Right(position);
    } catch (e) {
      return Left(LocationFailure('Failed to get location: $e'));
    }
  }
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}
