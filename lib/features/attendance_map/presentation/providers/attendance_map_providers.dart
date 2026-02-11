import 'package:geolocator/geolocator.dart';
import 'package:hr_connect/features/attendance/domain/entities/attendance.dart';
import 'package:hr_connect/features/attendance/domain/usecases/check_in.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:hr_connect/features/attendance_map/presentation/providers/attendance_map_states.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'attendance_map_providers.g.dart';

@riverpod
class AttendanceMapNotifier extends _$AttendanceMapNotifier {
  @override
  AttendanceMapState build() {
    _fetchLocation();
    return AttendanceMapLoading();
  }

  Future<void> _fetchLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled. Please enable GPS.';
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied. Please enable in settings.';
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final latLng = LatLng(position.latitude, position.longitude);
      final distance = Geolocator.distanceBetween(
        CheckIn.officeLat,
        CheckIn.officeLong,
        position.latitude,
        position.longitude,
      );

      state = AttendanceMapLocated(
        currentLocation: latLng,
        isWithinRadius: distance <= CheckIn.maxDistanceInMeters,
        distanceToOffice: distance,
      );
    } catch (e) {
      state = AttendanceMapError(e.toString(), source: 'location');
    }
  }

  Future<void> refreshLocation() async {
    state = AttendanceMapLoading();
    await _fetchLocation();
  }

  Future<void> confirmCheckIn() async {
    final current = state;
    if (current is! AttendanceMapLocated || current.isProcessing) return;

    state = current.copyWith(isProcessing: true);

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      state = const AttendanceMapError(
        'User not authenticated',
        source: 'confirm',
      );
      return;
    }

    await ref.read(attendanceProvider.notifier).checkIn(
      employeeId: userId,
      locationType: LocationType.wfo,
      lat: current.currentLocation.latitude,
      long: current.currentLocation.longitude,
    );

    state = AttendanceMapSuccess();
  }

  Future<void> confirmCheckOut(String attendanceId) async {
    final current = state;
    if (current is! AttendanceMapLocated || current.isProcessing) return;

    state = current.copyWith(isProcessing: true);

    await ref.read(attendanceProvider.notifier).checkOut(attendanceId);

    state = AttendanceMapSuccess();
  }
}
