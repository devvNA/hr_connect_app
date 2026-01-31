import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/approval_list_item.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/attendance_donut.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/home_drawer.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/home_header.dart';
import 'package:hr_connect/features/home_dashboard/presentation/widgets/home_stats_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final EmployeeEntity employee;

  const HomeScreen({super.key, required this.employee});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Current date formatter
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, d MMM').format(now);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: HomeDrawer(employee: widget.employee),
      appBar: HomeHeader(
        employee: widget.employee,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 24),
          // Welcome & Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateString,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Good Morning,\n${widget.employee.fullName}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppColors.shadowSoft,
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search employees, actions...',
                      hintStyle: TextStyle(color: AppColors.textLight),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textLight,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Stats Carousel
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(width: 16),
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
                const SizedBox(width: 16),
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

          const SizedBox(height: 24),

          // Today's Overview Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
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
                    const SizedBox(width: 16),
                    // Who is Away Widget
                    Expanded(
                      child: Container(
                        height: 190, // Match donut height roughly
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: AppColors.shadowCard,
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.beach_access,
                                    color: AppColors.warning,
                                    size: 20,
                                  ),
                                ),
                                const Text(
                                  '4',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              'Employees on leave',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
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
                                      child: const Center(
                                        child: Text(
                                          '+1',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
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

          const SizedBox(height: 24),

          // Pending Approvals
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pending Approvals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
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
