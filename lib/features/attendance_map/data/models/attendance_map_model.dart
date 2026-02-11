import 'package:hr_connect/features/attendance_map/domain/entities/attendance_map_entity.dart';

class AttendanceMapModel extends AttendanceMapEntity {
  const AttendanceMapModel({
    required super.id,
    required super.name,
    super.address,
    required super.latitude,
    required super.longitude,
    required super.radiusMeters,
    super.isActive,
  });

  factory AttendanceMapModel.fromJson(Map<String, dynamic> json) {
    return AttendanceMapModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radius_meters'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
