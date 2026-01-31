import 'package:flutter/material.dart' hide NavigationDestination;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/theme/app_color.dart';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 1. Header Section: User Profile
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
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
                            boxShadow: AppColors.shadowSoft,
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            employee.fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            employee.role.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
                const SizedBox(height: 8),
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
                        const Text(
                          'View Profile',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
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
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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

          // 3. Bottom Section: Sign Out & Version
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.error, size: 24),
                        SizedBox(width: 16),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: Text(
                    'v1.0.0+1',
                    style: TextStyle(
                      fontSize: 12,
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
          style: const TextStyle(
            fontSize: 20,
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
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Scaffold.of(context).closeDrawer();
            ref.read(navigationProvider.notifier).state = destination;
            context.go(destination.path);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? AppColors.primaryDark
                          : AppColors.textSecondary,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (badgeCount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
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
