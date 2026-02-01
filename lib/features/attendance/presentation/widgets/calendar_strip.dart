import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class CalendarStrip extends StatefulWidget {
  final Function(DateTime)? onDateSelected;

  const CalendarStrip({super.key, this.onDateSelected});

  @override
  State<CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends State<CalendarStrip> {
  late List<DateTime> _dates;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dates = _generateDates();
  }

  List<DateTime> _generateDates() {
    final now = DateTime.now();
    // Start from today and go forward 6 days (total 7 days shown)
    // Or we could show current week (Sun-Sat or Mon-Sun).
    // Let's show a rolling week starting from today or slightly before.
    // The design often implies a broader view, but let's stick to "Current Week" logic
    // or +- 3 days. A simple useful approach for attendance is "This Week".

    // Find previous Sunday (or Monday depending on locale, sticking to Sun for now)
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday % 7));

    return List.generate(7, (index) {
      return firstDayOfWeek.add(Duration(days: index));
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          ..._dates.map((date) {
            final isSelected = _isSameDay(date, _selectedDate);
            final isToday = _isSameDay(date, DateTime.now());
            final dayName = DateFormat('E').format(date); // Sun, Mon, etc.
            final dayNumber = DateFormat('d').format(date); // 22, 23, etc.

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected?.call(date);
                },
                child: isSelected
                    ? _buildActiveDayItem(dayName, dayNumber, isToday)
                    : _buildDayItem(dayName, dayNumber, isToday),
              ),
            );
          }),
          _buildCalendarIcon(),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, String date, bool isToday) {
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
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDayItem(String day, String date, bool isToday) {
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
              decoration: BoxDecoration(
                color: isToday ? Colors.white : Colors.transparent,
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
