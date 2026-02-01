import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

class CalendarStrip extends StatelessWidget {
  const CalendarStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          _buildDayItem('Sun', '22'),
          const SizedBox(width: 12),
          _buildDayItem('Mon', '23'),
          const SizedBox(width: 12),
          _buildActiveDayItem('Tue', '24'),
          const SizedBox(width: 12),
          _buildDayItem('Wed', '25'),
          const SizedBox(width: 12),
          _buildDayItem('Thu', '26'),
          const SizedBox(width: 12),
          _buildCalendarIcon(),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, String date) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
      ),
      child: Column(
        children: [
          Text(
            day,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            date,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDayItem(String day, String date) {
    return Transform.scale(
      scale: 1.05,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadius.lgRadius,
          boxShadow: AppShadows.primary,
        ),
        child: Column(
          children: [
            Text(
              day,
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              date,
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarIcon() {
    return Container(
      width: 60,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.calendar_month, color: AppColors.textLight),
      ),
    );
  }
}
