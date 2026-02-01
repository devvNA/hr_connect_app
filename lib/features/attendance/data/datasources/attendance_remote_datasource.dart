import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/attendance.dart';
import '../models/attendance_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceModel> checkIn(
    String employeeId,
    LocationType locationType,
    double lat,
    double long,
  );
  Future<AttendanceModel> checkOut(String attendanceId);
  Future<AttendanceModel?> getTodayAttendance(String employeeId);
  Future<List<AttendanceModel>> getMonthlyAttendance(
    String employeeId,
    int month,
    int year,
  );
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final SupabaseClient supabaseClient;

  AttendanceRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<AttendanceModel> checkIn(
    String employeeId,
    LocationType locationType,
    double lat,
    double long,
  ) async {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);

    // Determine status (Simple logic: Late if after 9:00 AM)
    final isLate = now.hour > 9 || (now.hour == 9 && now.minute > 0);
    final status = isLate ? 'Late' : 'On Time';
    final locationStr = locationType == LocationType.wfo
        ? 'WFO'
        : (locationType == LocationType.wfh ? 'WFH' : 'On Site');

    final response = await supabaseClient
        .from('attendance')
        .insert({
          'employee_id': employeeId,
          'date': dateStr,
          'check_in': now.toIso8601String(),
          'status': status,
          'location_type': locationStr,
          'check_in_lat': lat,
          'check_in_long': long,
          // 'check_out' is null initially
        })
        .select()
        .single();

    return AttendanceModel.fromJson(response);
  }

  @override
  Future<AttendanceModel> checkOut(String attendanceId) async {
    final now = DateTime.now();
    final response = await supabaseClient
        .from('attendance')
        .update({'check_out': now.toIso8601String()})
        .eq('id', attendanceId)
        .select()
        .single();

    return AttendanceModel.fromJson(response);
  }

  @override
  Future<AttendanceModel?> getTodayAttendance(String employeeId) async {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);

    final response = await supabaseClient
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .eq('date', dateStr)
        .maybeSingle();

    if (response == null) return null;
    return AttendanceModel.fromJson(response);
  }

  @override
  Future<List<AttendanceModel>> getMonthlyAttendance(
    String employeeId,
    int month,
    int year,
  ) async {
    // Using RPC function created earlier
    final response = await supabaseClient.rpc(
      'get_monthly_attendance',
      params: {'p_employee_id': employeeId, 'p_month': month, 'p_year': year},
    );

    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => AttendanceModel.fromJson(json)).toList();
  }
}
