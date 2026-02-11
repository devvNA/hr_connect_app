import 'package:hr_connect/features/attendance_map/domain/entities/attendance_map_entity.dart';
import 'package:latlong2/latlong.dart';

sealed class AttendanceMapState {
  const AttendanceMapState();
}

class AttendanceMapInitial extends AttendanceMapState {}

class AttendanceMapLoading extends AttendanceMapState {}

class AttendanceMapLocated extends AttendanceMapState {
  final LatLng currentLocation;
  final bool isWithinRadius;
  final double distanceToOffice;
  final AttendanceMapEntity office;
  final bool isProcessing;

  const AttendanceMapLocated({
    required this.currentLocation,
    required this.isWithinRadius,
    required this.distanceToOffice,
    required this.office,
    this.isProcessing = false,
  });

  AttendanceMapLocated copyWith({
    LatLng? currentLocation,
    bool? isWithinRadius,
    double? distanceToOffice,
    AttendanceMapEntity? office,
    bool? isProcessing,
  }) {
    return AttendanceMapLocated(
      currentLocation: currentLocation ?? this.currentLocation,
      isWithinRadius: isWithinRadius ?? this.isWithinRadius,
      distanceToOffice: distanceToOffice ?? this.distanceToOffice,
      office: office ?? this.office,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class AttendanceMapSuccess extends AttendanceMapState {}

class AttendanceMapError extends AttendanceMapState {
  final String message;
  final String? source;
  const AttendanceMapError(this.message, {this.source});
}
