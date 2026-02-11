import 'package:flutter/material.dart' hide NavigationDestination;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_providers.dart';
import 'package:hr_connect/features/base/presentation/providers/navigation_provider.dart';

/// Persistent app drawer used across all main screens
class AppDrawer extends ConsumerWidget {
  final EmployeeEntity employee;

  const AppDrawer({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDestination = ref.watch(navigationProvider);

    return Drawer(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 1. Header Section: User Profile
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              48,
              AppSpacing.xxl,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: AppShadows.small,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              employee.avatarUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildPlaceholder(),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surface,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            employee.fullName,
                            style: AppTypography.headlineSmall.copyWith(
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            employee.role.name.toUpperCase(),
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    ref.read(navigationProvider.notifier).state =
                        NavigationDestination.profile;
                    context.go(NavigationDestination.profile.path);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Profile',
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),

          // 2. Navigation List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xxl,
                horizontal: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    ref: ref,
                    icon: Icons.grid_view_rounded,
                    label: 'Dashboard',
                    destination: NavigationDestination.dashboard,
                    isActive:
                        currentDestination == NavigationDestination.dashboard,
                  ),
                  _buildMenuItem(
                    context: context,
                    ref: ref,
                    icon: Icons.group_outlined,
                    label: 'Employees',
                    destination: NavigationDestination.employees,
                    isActive:
                        currentDestination == NavigationDestination.employees,
                  ),
                  _buildMenuItem(
                    context: context,
                    ref: ref,
                    icon: Icons.calendar_today_outlined,
                    label: 'Attendance',
                    destination: NavigationDestination.attendance,
                    isActive:
                        currentDestination == NavigationDestination.attendance,
                  ),
                  _buildMenuItem(
                    context: context,
                    ref: ref,
                    icon: Icons.flight_takeoff,
                    label: 'Leave Requests',
                    destination: NavigationDestination.leaveRequests,
                    isActive:
                        currentDestination ==
                        NavigationDestination.leaveRequests,
                  ),
                  if (employee.isAdmin)
                    _buildMenuItem(
                      context: context,
                      ref: ref,
                      icon: Icons.check_circle_outline,
                      label: 'Approvals',
                      destination: NavigationDestination.approvals,
                      badgeCount: 3,
                      isActive:
                          currentDestination == NavigationDestination.approvals,
                    ),
                  _buildMenuItem(
                    context: context,
                    ref: ref,
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    destination: NavigationDestination.settings,
                    isActive:
                        currentDestination == NavigationDestination.settings,
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Section: Logo, Sign Out & Version
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: AppSpacing.lg),
                InkWell(
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  borderRadius: AppRadius.mdRadius,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(borderRadius: AppRadius.mdRadius),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: AppColors.error,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Text(
                          'Sign Out',
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.lg,
                    top: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                  ),
                  child: Text(
                    'v1.0.0+1',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
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

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Text(
          employee.fullName.isNotEmpty
              ? employee.fullName[0].toUpperCase()
              : '?',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required String label,
    required NavigationDestination destination,
    bool isActive = false,
    int? badgeCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Scaffold.of(context).closeDrawer();
            ref.read(navigationProvider.notifier).state = destination;
            context.go(destination.path);
          },
          borderRadius: AppRadius.mdRadius,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryContainer : Colors.transparent,
              borderRadius: AppRadius.mdRadius,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.labelLarge.copyWith(
                      color: isActive
                          ? AppColors.primaryDark
                          : AppColors.textSecondary,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                if (badgeCount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.mdRadius,
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
