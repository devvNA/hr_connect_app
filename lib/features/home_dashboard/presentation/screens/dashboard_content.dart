import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/approval_list_item.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/attendance_donut.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/home_stats_card.dart';
import 'package:intl/intl.dart';

/// Dashboard content - to be used inside MainShell
class DashboardContent extends ConsumerWidget {
  final EmployeeEntity employee;

  const DashboardContent({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, d MMM').format(now);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Quick action
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          // Welcome & Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateString,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Good Morning,\n${employee.fullName.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ')}',
                  style: AppTypography.displaySmall.copyWith(
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.mdRadius,
                    boxShadow: AppShadows.small,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search employees, actions...',
                      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textLight,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.lg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Quick Stats Carousel
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                const HomeStatsCard(
                  icon: Icons.groups_outlined,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primaryContainer,
                  label: 'Total Staff',
                  value: '1,240',
                  changeLabel: '+12%',
                  changeColor: AppColors.success,
                  changeBgColor: AppColors.successContainer,
                ),
                const SizedBox(width: AppSpacing.lg),
                const HomeStatsCard(
                  icon: Icons.person_add_outlined,
                  iconColor: AppColors.purple,
                  iconBgColor: AppColors.purpleContainer,
                  label: 'New Hires',
                  value: '8',
                  changeLabel: 'Week',
                  changeColor: AppColors.purple,
                  changeBgColor: AppColors.purpleContainer,
                ),
                const SizedBox(width: AppSpacing.lg),
                HomeStatsCard(
                  icon: Icons.trending_down,
                  iconColor: AppColors.warning,
                  iconBgColor: AppColors.warningContainer,
                  label: 'Attrition',
                  value: '1.5%',
                  changeLabel: '-0.2%',
                  changeColor: AppColors.success,
                  changeBgColor: AppColors.successContainer,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Today's Overview Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Overview",
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    // Attendance Widget
                    const Expanded(
                      child: AttendanceDonut(
                        percentage: 0.92,
                        lateCount: 20,
                        absentCount: 50,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    // Who is Away Widget
                    Expanded(
                      child: Container(
                        height: 190,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.lgRadius,
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.warningContainer,
                                    borderRadius: AppRadius.smRadius,
                                  ),
                                  child: const Icon(
                                    Icons.beach_access,
                                    color: AppColors.warning,
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  '4',
                                  style: AppTypography.displaySmall,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              'Employees on leave',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            SizedBox(
                              height: 32,
                              child: Stack(
                                children: [
                                  _buildAvatar(
                                    0,
                                    'https://i.pravatar.cc/100?img=5',
                                  ),
                                  _buildAvatar(
                                    24,
                                    'https://i.pravatar.cc/100?img=8',
                                  ),
                                  _buildAvatar(
                                    48,
                                    'https://i.pravatar.cc/100?img=3',
                                  ),
                                  Positioned(
                                    left: 72,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.surface,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+1',
                                          style: AppTypography.labelSmall.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Pending Approvals - Only visible for Admin role
          if (employee.isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pending Approvals',
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View all',
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ApprovalListItem(
                    name: 'Sarah Jenkins',
                    timeAgo: '2h ago',
                    title: 'Annual Leave Request',
                    details: 'Oct 12 - Oct 15 • 3 Days',
                    icon: Icons.calendar_month,
                    onApprove: () {},
                    onReject: () {},
                    avatarUrl: 'https://i.pravatar.cc/100?img=1',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ApprovalListItem(
                    name: 'Mike Ross',
                    timeAgo: '5h ago',
                    title: 'Expense Claim • Travel',
                    details: 'taxi_receipt.pdf',
                    attachmentName: 'taxi_receipt.pdf',
                    amount: '\$45.00',
                    icon: Icons.attach_file,
                    onApprove: () {},
                    onReject: () {},
                    avatarUrl: 'https://i.pravatar.cc/100?img=11',
                  ),
                ],
              ),
            ),

          // Bottom Spacer
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAvatar(double left, String url) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surface, width: 2),
          color: AppColors.background,
        ),
        child: ClipOval(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.person,
                size: 16,
                color: AppColors.textLight,
              );
            },
          ),
        ),
      ),
    );
  }
}
