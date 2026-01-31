import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';
import 'package:hr_connect/features/profile/presentation/widgets/activity_timeline_item.dart';
import 'package:hr_connect/features/profile/presentation/widgets/document_item.dart';
import 'package:hr_connect/features/profile/presentation/widgets/profile_action_button.dart';
import 'package:hr_connect/features/profile/presentation/widgets/profile_info_item.dart';
import 'package:hr_connect/features/profile/presentation/widgets/profile_info_section.dart';

/// Profile content - to be used inside MainShell
class ProfileContent extends StatelessWidget {
  final EmployeeEntity employee;

  const ProfileContent({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHRBanner()),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildProfileHeader(context),
            _buildActionButtons(),
            _buildContent(context),
          ]),
        ),
      ],
    );
  }

  Widget _buildHRBanner() {
    return Container(
      width: double.infinity,
      color: AppColors.primary.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'HR ADMIN VIEW • FULL ACCESS',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: AppColors.shadowCard,
                  color: AppColors.background,
                ),
                child: ClipOval(
                  child: Image.network(
                    employee.avatarUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          employee.fullName.isNotEmpty
                              ? employee.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            employee.fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            employee.jobTitle ?? 'Employee',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successContainer,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'ACTIVE EMPLOYEE',
              style: TextStyle(
                color: AppColors.success,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ProfileActionButton(icon: Icons.call, label: 'Call', onTap: () {}),
          ProfileActionButton(icon: Icons.email, label: 'Email', onTap: () {}),
          ProfileActionButton(
            icon: Icons.chat_bubble,
            label: 'Message',
            onTap: () {},
          ),
          ProfileActionButton(
            icon: Icons.account_tree,
            label: 'Org Chart',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Personal Info
          ProfileInfoSection(
            title: 'Personal Info',
            action: InkWell(
              onTap: () {},
              child: Text(
                'EDIT',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            children: [
              const ProfileInfoItem(
                icon: Icons.cake,
                label: 'Date of Birth',
                value: 'Oct 24, 1990',
              ),
              ProfileInfoItem(
                icon: Icons.smartphone,
                label: 'Phone Number',
                value: employee.phone ?? 'Not set',
              ),
              const ProfileInfoItem(
                icon: Icons.location_on,
                label: 'Home Address',
                value: '123 Design Blvd, NY 10001',
                trailing: Icon(
                  Icons.visibility_off,
                  size: 18,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Job Details
          ProfileInfoSection(
            title: 'Job Details',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildJobDetailBox(
                      context,
                      'Department',
                      'Product Design',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildJobDetailBox(
                      context,
                      'Employee ID',
                      'UX-2023-09',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Reporting to',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Robert Fox',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/100?img=12',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Documents
          ProfileInfoSection(
            title: 'Documents',
            action: InkWell(
              onTap: () {},
              child: Text(
                'VIEW ALL',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            children: [
              DocumentItem(
                icon: Icons.description,
                iconColor: AppColors.error,
                iconBgColor: AppColors.error.withValues(alpha: 0.1),
                title: 'Employment_Contract.pdf',
                subtitle: 'Added on Aug 1, 2023 • 2.4 MB',
                onDownload: () {},
              ),
              const SizedBox(height: 8),
              DocumentItem(
                icon: Icons.image,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primary.withValues(alpha: 0.1),
                title: 'Passport_Scan_Copy.jpg',
                subtitle: 'Added on Jul 28, 2023 • 1.1 MB',
                onDownload: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Activity Timeline
          ProfileInfoSection(
            title: 'Recent Activity',
            children: [
              ActivityTimelineItem(
                title: 'Promoted to Senior UX Designer',
                subtitle: 'October 15, 2023 • By HR Admin',
                dotColor: AppColors.primary,
              ),
              ActivityTimelineItem(
                title: 'Performance Review Completed',
                subtitle: 'September 1, 2023 • Score: 4.8/5',
                dotColor: Colors.grey,
              ),
              const ActivityTimelineItem(
                title: 'Address Updated',
                subtitle: 'July 12, 2023 • By Jane Doe',
                dotColor: Colors.grey,
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildJobDetailBox(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
