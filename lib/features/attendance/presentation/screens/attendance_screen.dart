import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/activity_history_list.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/attendance_metrics.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/calendar_strip.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/check_in_card.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/corrections_widget.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Greeting
          Text(
            'Good Morning, Alex.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ready for another productive day?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 24),

          // Calendar Strip
          CalendarStrip(),
          SizedBox(height: 24),

          // Check In Card
          CheckInCard(),
          SizedBox(height: 24),

          // Metrics
          AttendanceMetrics(),
          SizedBox(height: 24),

          // Corrections
          CorrectionsWidget(),
          SizedBox(height: 24),

          // History
          ActivityHistoryList(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
