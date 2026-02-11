import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/core/utils/date_formatter.dart';
import 'package:hr_connect/core/utils/shimmering.dart';

/// Represents the current state of attendance for the card display.
enum AttendanceCardState {
  /// User has not checked in yet today
  notCheckedIn,

  /// User is currently working (checked in, not checked out)
  working,

  /// User has completed the shift (checked in and checked out)
  completed,
}

class CheckInCard extends StatelessWidget {
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final VoidCallback? onShiftSummary;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  const CheckInCard({
    super.key,
    this.onCheckIn,
    this.onCheckOut,
    this.onShiftSummary,
    this.checkInTime,
    this.checkOutTime,
  });

  AttendanceCardState get _cardState {
    if (checkInTime == null) return AttendanceCardState.notCheckedIn;
    if (checkOutTime == null) return AttendanceCardState.working;
    return AttendanceCardState.completed;
  }

  @override
  Widget build(BuildContext context) {
    return switch (_cardState) {
      AttendanceCardState.notCheckedIn => _buildNotCheckedInCard(),
      AttendanceCardState.working => _buildWorkingCard(),
      AttendanceCardState.completed => _buildCompletedCard(),
    };
  }

  /// Build card for "Not Checked In" state
  Widget _buildNotCheckedInCard() {
    final now = DateTime.now();
    final timeStr = DateFormatter.formatTime(now);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.card,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'SHIFT: 08:30 - 17:00',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: timeStr,
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 40,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: ' WIB',
                            style: AppTypography.headlineSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Office Network', style: AppTypography.bodySmall),
                  ],
                ),
                // Mini Map Container
                _buildMapContainer(),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Check In Button
            _buildActionButton(
              onTap: onCheckIn,
              icon: Icons.fingerprint,
              label: 'Check In Now',
              backgroundColor: AppColors.primary,
              boxShadow: AppShadows.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Build card for "Working" state (checked in, not checked out)
  Widget _buildWorkingCard() {
    final now = DateTime.now();
    final timeStr = DateFormatter.formatTime(now);
    final workDuration = _calculateWorkDuration(checkInTime!, now);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.successContainer.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.card,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Working Status Badge
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'WORKING FOR $workDuration',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Current Time
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: timeStr,
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 40,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: ' WIB',
                            style: AppTypography.headlineSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Check-in info
                    Text(
                      'In at ${DateFormatter.formatTime(checkInTime!)} • Office Network',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                // Mini Map Container
                _buildMapContainer(),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Check Out Button
            _buildActionButton(
              onTap: onCheckOut,
              icon: Icons.fingerprint,
              label: 'Check Out Now',
              backgroundColor: AppColors.warning,
              boxShadow: AppShadows.medium,
            ),
          ],
        ),
      ),
    );
  }

  /// Build card for "Completed" state (checked in and checked out)
  Widget _buildCompletedCard() {
    final totalDuration = _calculateWorkDuration(checkInTime!, checkOutTime!);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.primaryContainer.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.card,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Completed Status Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'SHIFT COMPLETED',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Total Duration
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: totalDuration,
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 40,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: ' total',
                            style: AppTypography.headlineSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Check-in and Check-out times
                    Row(
                      children: [
                        _buildTimeColumn('CHECK IN', checkInTime!),
                        const SizedBox(width: AppSpacing.xxxl),
                        _buildTimeColumn('CHECK OUT', checkOutTime!),
                      ],
                    ),
                  ],
                ),
                // Trophy Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_events_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Shift Summary Button
            InkWell(
              onTap: onShiftSummary,
              borderRadius: AppRadius.mdRadius,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.mdRadius,
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppShadows.small,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.summarize_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'Shift Summary',
                      style: AppTypography.button.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapContainer() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: Colors.white),
        boxShadow: AppShadows.small,
      ),
      child: const Center(
        child: Icon(
          Icons.location_on,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onTap,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required List<BoxShadow> boxShadow,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.mdRadius,
          boxShadow: boxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTypography.button),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String label, DateTime time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          DateFormatter.formatTime(time),
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _calculateWorkDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}

class CheckInCardShimmer extends StatelessWidget {
  const CheckInCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.card,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonShimmer(width: 150, height: 20, borderRadius: 4),
                    SizedBox(height: AppSpacing.sm),
                    SkeletonShimmer(width: 180, height: 48, borderRadius: 8),
                    SizedBox(height: AppSpacing.sm),
                    SkeletonShimmer(width: 100, height: 14, borderRadius: 4),
                  ],
                ),
                const SkeletonShimmer(width: 48, height: 48, borderRadius: 12),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            const SkeletonShimmer(
              width: double.infinity,
              height: 56,
              borderRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}
