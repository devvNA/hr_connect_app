import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

class ActivityHistoryList extends StatelessWidget {
  const ActivityHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            'Recent Activity',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgRadius,
            boxShadow: AppShadows.card,
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildActivityRow(
                date: '23',
                month: 'Oct',
                timeRange: '09:00 - 18:00',
                duration: '9h 00m',
                status: 'Regular',
                statusColor: AppColors.success,
                statusBgColor: AppColors.successContainer,
              ),
              const Divider(height: 1, color: AppColors.border),
              _buildActivityRow(
                date: '20',
                month: 'Oct',
                timeRange: '09:15 - 18:00',
                duration: '8h 45m',
                status: 'Late (15m)',
                statusColor: const Color(0xFFB45309), // amber-700
                statusBgColor: AppColors.warningContainer,
              ),
              const Divider(height: 1, color: AppColors.border),
              _buildActivityRow(
                date: '19',
                month: 'Oct',
                timeRange: '08:55 - 18:05',
                duration: '9h 10m',
                status: 'Regular',
                statusColor: AppColors.success,
                statusBgColor: AppColors.successContainer,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityRow({
    required String date,
    required String month,
    required String timeRange,
    required String duration,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.smRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                Text(
                  month,
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeRange,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(duration, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: AppRadius.xsRadius,
            ),
            child: Text(
              status,
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
