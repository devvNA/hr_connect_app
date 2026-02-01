import 'package:equatable/equatable.dart';

enum AttendanceStatus { onTime, late, absent, earlyLeave }

enum LocationType { wfo, wfh, onSite }

class Attendance extends Equatable {
  final String id;
  final String employeeId;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final AttendanceStatus? status;
  final LocationType? locationType;
  final double? checkInLat;
  final double? checkInLong;

  const Attendance({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.status,
    this.locationType,
    this.checkInLat,
    this.checkInLong,
  });

  @override
  List<Object?> get props => [
    id,
    employeeId,
    date,
    checkIn,
    checkOut,
    status,
    locationType,
    checkInLat,
    checkInLong,
  ];
}
