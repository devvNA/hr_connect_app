class AttendanceMapEntity {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool isActive;

  const AttendanceMapEntity({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.isActive = true,
  });
}
