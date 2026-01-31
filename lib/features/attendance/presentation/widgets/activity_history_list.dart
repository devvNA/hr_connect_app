import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';

class ActivityHistoryList extends StatelessWidget {
  const ActivityHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.shadowCard,
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
                statusColor: Color(0xFFB45309), // amber-700
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                Text(
                  month,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeRange,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
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
