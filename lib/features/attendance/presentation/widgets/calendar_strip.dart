import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        // No border for inactive as per design (or transparent)
      ),
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
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
      height: 72, // Approx height to match others
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border, // dashed border simulated
          width: 2,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.calendar_month,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
