import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/utils/shimmering.dart';
import 'package:hr_connect/features/employee/presentation/providers/employee_providers.dart';
import 'package:hr_connect/features/employee/presentation/providers/employee_states.dart';
import 'package:hr_connect/features/employee/presentation/widgets/employee_card.dart';
import 'package:hr_connect/features/employee/presentation/widgets/employee_search_bar.dart';
import 'package:hr_connect/features/employee/presentation/widgets/filter_chip_list.dart';

class EmployeeListScreen extends ConsumerWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeListProvider);
    final employeeCount = ref.watch(employeeCountProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              EmployeeSearchBar(
                onSearch: (query) =>
                    ref.read(employeeListProvider.notifier).search(query),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              const FilterChipList(),
              const SizedBox(height: 16),

              // List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL EMPLOYEES ($employeeCount)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Employee List
        Expanded(
          child: switch (employeeState) {
            EmployeeListLoading() => _buildLoadingList(),
            EmployeeListError(message: final msg) => _buildError(msg, ref),
            EmployeeListLoaded(employees: final employees) =>
              employees.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () =>
                          ref.read(employeeListProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return EmployeeCard(
                            name: employee.fullName,
                            role: employee.jobTitle,
                            department: employee.departmentName,
                            imageUrl:
                                employee.avatarUrl ??
                                "https://res.cloudinary.com/dotz74j1p/raw/upload/v1716044999/t3jxwmbgwelsvgsmby4c.png",
                            status: employee.status,
                            statusColor: _getStatusColor(employee.status),
                            statusBgColor: _getStatusBgColor(employee.status),
                          );
                        },
                      ),
                    ),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Avatar skeleton
            const SkeletonShimmer(width: 48, height: 48, borderRadius: 24),
            const SizedBox(width: 16),
            // Text info skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonShimmer(
                    width: double.infinity,
                    height: 16,
                    borderRadius: 4,
                  ),
                  SizedBox(height: 8),
                  SkeletonShimmer(width: 120, height: 12, borderRadius: 4),
                  SizedBox(height: 6),
                  SkeletonShimmer(width: 80, height: 10, borderRadius: 4),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Status skeleton
            const SkeletonShimmer(width: 60, height: 24, borderRadius: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load employees',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(employeeListProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No employees found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    return switch (status) {
      'Active' => AppColors.success,
      'Inactive' => const Color(0xFF4B5563), // gray-600
      'On Leave' => const Color(0xFFB45309), // amber-700
      'Probation' => const Color(0xFF1D4ED8), // blue-700
      _ => AppColors.textSecondary,
    };
  }

  Color _getStatusBgColor(String status) {
    return switch (status) {
      'Active' => AppColors.successContainer,
      'Inactive' => const Color(0xFFF9FAFB), // gray-50
      'On Leave' => const Color(0xFFFFFBEB), // amber-50
      'Probation' => const Color(0xFFEFF6FF), // blue-50
      _ => AppColors.surface,
    };
  }
}
