import 'package:intl/intl.dart';

import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.id,
    required super.employeeId,
    required super.date,
    super.checkIn,
    super.checkOut,
    super.status,
    super.locationType,
    super.checkInLat,
    super.checkInLong,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      employeeId: json['employee_id'],
      date: DateTime.parse(json['date']),
      checkIn: json['check_in'] != null
          ? DateTime.parse(json['check_in'])
          : null,
      checkOut: json['check_out'] != null
          ? DateTime.parse(json['check_out'])
          : null,
      status: _statusFromString(json['status']),
      locationType: _locationFromString(json['location_type']),
      checkInLat: json['check_in_lat'] != null
          ? (json['check_in_lat'] as num).toDouble()
          : null,
      checkInLong: json['check_in_long'] != null
          ? (json['check_in_long'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'check_in': checkIn?.toIso8601String(),
      'check_out': checkOut?.toIso8601String(),
      'status': _statusToString(status),
      'location_type': _locationToString(locationType),
      'check_in_lat': checkInLat,
      'check_in_long': checkInLong,
    };
  }

  static AttendanceStatus? _statusFromString(String? status) {
    if (status == null) return null;
    switch (status) {
      case 'On Time':
        return AttendanceStatus.onTime;
      case 'Late':
        return AttendanceStatus.late;
      case 'Absent':
        return AttendanceStatus.absent;
      case 'Early Leave':
        return AttendanceStatus.earlyLeave;
      default:
        return null;
    }
  }

  static String? _statusToString(AttendanceStatus? status) {
    if (status == null) return null;
    switch (status) {
      case AttendanceStatus.onTime:
        return 'On Time';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.earlyLeave:
        return 'Early Leave';
    }
  }

  static LocationType? _locationFromString(String? loc) {
    if (loc == null) return null;
    switch (loc) {
      case 'WFO':
        return LocationType.wfo;
      case 'WFH':
        return LocationType.wfh;
      case 'On Site':
        return LocationType.onSite;
      default:
        return null;
    }
  }

  static String? _locationToString(LocationType? loc) {
    if (loc == null) return null;
    switch (loc) {
      case LocationType.wfo:
        return 'WFO';
      case LocationType.wfh:
        return 'WFH';
      case LocationType.onSite:
        return 'On Site';
    }
  }
}
