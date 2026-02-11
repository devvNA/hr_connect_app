import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/attendance/domain/entities/attendance.dart';
import 'package:hr_connect/features/attendance_map/presentation/screens/attendance_map_screen.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:hr_connect/features/attendance/presentation/providers/attendance_states.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/activity_history_list.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/attendance_metrics.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/calendar_strip.dart';
import 'package:hr_connect/features/attendance/presentation/widgets/check_in_card.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_providers.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_states.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    final authState = ref.watch(authProvider);

    final userName = switch (authState) {
      AuthLoaded(:final employee) => employee.fullName,
      _ => 'Employee',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(attendanceProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Good Morning, $userName.',
                style: AppTypography.displaySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Ready for another productive day?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Calendar Strip
              const CalendarStrip(),
              const SizedBox(height: AppSpacing.xxl),

              // Check In/Out Card
              _buildCheckInCard(context, ref, attendanceState),
              const SizedBox(height: 24),

              // Metrics
              const AttendanceMetrics(),
              const SizedBox(height: 24),

              // History
              const ActivityHistoryList(),

              // Error display
              if (attendanceState is AttendanceError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    attendanceState.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInCard(
    BuildContext context,
    WidgetRef ref,
    AttendanceState state,
  ) {
    return switch (state) {
      AttendanceLoading() => const CheckInCardShimmer(),
      AttendanceLoaded(:final todayAttendance) =>
        _buildCheckInCardContent(context, ref, todayAttendance),
      AttendanceError(:final message) => Center(
        child: Column(
          children: [
            Text('Error: $message', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => ref.read(attendanceProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildCheckInCardContent(
    BuildContext context,
    WidgetRef ref,
    Attendance? attendance,
  ) {
    final hasCheckedIn = attendance?.checkIn != null;
    final hasCheckedOut = attendance?.checkOut != null;

    return CheckInCard(
      checkInTime: attendance?.checkIn,
      checkOutTime: attendance?.checkOut,
      onCheckIn: (hasCheckedIn || hasCheckedOut)
          ? null
          : () async {
              final result = await context.push<bool>(
                '/attendance/map',
                extra: {'mode': AttendanceMapMode.checkIn},
              );
              if (result == true) {
                ref.read(attendanceProvider.notifier).refresh();
              }
            },
      onCheckOut: (hasCheckedOut || !hasCheckedIn)
          ? null
          : () async {
              final result = await context.push<bool>(
                '/attendance/map',
                extra: {
                  'mode': AttendanceMapMode.checkOut,
                  'attendanceId': attendance!.id,
                },
              );
              if (result == true) {
                ref.read(attendanceProvider.notifier).refresh();
              }
            },
      onShiftSummary: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shift Summary coming soon!')),
        );
      },
    );
  }

}
