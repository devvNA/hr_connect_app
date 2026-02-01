import 'package:flutter/material.dart' hide NavigationDestination;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';
import 'package:hr_connect/features/base/presentation/providers/navigation_provider.dart';

/// Persistent app header/appbar used across all main screens
class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final EmployeeEntity employee;
  final VoidCallback onMenuPressed;
  final VoidCallback onNotificationPressed;

  const AppHeader({
    super.key,
    required this.employee,
    required this.onMenuPressed,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDestination = ref.watch(navigationProvider);
    final isDashboard = currentDestination == NavigationDestination.dashboard;
    final title = currentDestination.displayTitle;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    onPressed: onMenuPressed,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // HR Logo - only show on dashboard
                  if (isDashboard) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Center(
                        child: Text(
                          'HR',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  // Title
                  Text(
                    title,
                    style: AppTypography.displaySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: onNotificationPressed,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        constraints: const BoxConstraints(),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
