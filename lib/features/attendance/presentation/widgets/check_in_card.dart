import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/core/utils/date_formatter.dart';

class CheckInCard extends StatelessWidget {
  final Widget? mapWidget;
  final VoidCallback onCheckIn;
  final bool isLoading;
  final bool isCheckedIn;
  final DateTime? checkInTime;

  const CheckInCard({
    super.key,
    this.mapWidget,
    required this.onCheckIn,
    this.isLoading = false,
    this.isCheckedIn = false,
    this.checkInTime,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr = DateFormatter.formatTime(now);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.card,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          Padding(
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
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: AppRadius.mdRadius,
                        border: Border.all(color: Colors.white),
                        boxShadow: AppShadows.small,
                      ),
                      child: ClipRRect(
                        borderRadius: AppRadius.mdRadius,
                        child:
                            mapWidget ??
                            const Center(
                              child: Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                // Action Button
                InkWell(
                  onTap: isLoading ? null : onCheckIn,
                  borderRadius: AppRadius.mdRadius,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      color: isCheckedIn
                          ? AppColors.warning
                          : AppColors.primary,
                      borderRadius: AppRadius.mdRadius,
                      boxShadow: isCheckedIn
                          ? AppShadows.medium
                          : AppShadows.primary,
                    ),
                    child: isLoading
                        ? const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isCheckedIn ? Icons.logout : Icons.fingerprint,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text(
                                isCheckedIn ? 'Check Out Now' : 'Check In Now',
                                style: AppTypography.button,
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
