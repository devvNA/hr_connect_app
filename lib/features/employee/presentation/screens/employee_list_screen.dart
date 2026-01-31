import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/features/employee/presentation/widgets/employee_card.dart';
import 'package:hr_connect/features/employee/presentation/widgets/employee_search_bar.dart';
import 'package:hr_connect/features/employee/presentation/widgets/filter_chip_list.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              const EmployeeSearchBar(),
              const SizedBox(height: 16),

              // Filter Chips
              const FilterChipList(),
              const SizedBox(height: 16),

              // List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL EMPLOYEES (142)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Sort by: Name',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Employee List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            children: [
              EmployeeCard(
                name: 'Sarah Jenkins',
                role: 'Senior UX Designer',
                department: 'Product Team',
                imageUrl: 'https://i.pravatar.cc/100?img=5',
                status: 'Active',
                statusColor: AppColors.success, // green-700
                statusBgColor: AppColors.successContainer, // green-50
              ),
              EmployeeCard(
                name: 'David Okonjo',
                role: 'HR Specialist',
                department: 'People Ops',
                imageUrl: 'https://i.pravatar.cc/100?img=11',
                status: 'On Leave',
                statusColor: const Color(0xFFB45309), // amber-700
                statusBgColor: const Color(0xFFFFFBEB), // amber-50
              ),
              EmployeeCard(
                name: 'Michael Chen',
                role: 'Frontend Developer',
                department: 'Engineering',
                imageUrl: 'https://i.pravatar.cc/100?img=3',
                status: 'Remote',
                statusColor: const Color(0xFF1D4ED8), // blue-700
                statusBgColor: const Color(0xFFEFF6FF), // blue-50
              ),
              const EmployeeCard(
                name: 'Emma Wilson',
                role: 'Marketing Lead',
                department: 'Marketing',
                imageUrl: 'https://i.pravatar.cc/100?img=9',
                status: 'Active',
                statusColor: AppColors.success,
                statusBgColor: AppColors.successContainer,
              ),
              EmployeeCard(
                name: 'James Rodriguez',
                role: 'Former Sales Director',
                department: 'Sales',
                imageUrl: 'https://i.pravatar.cc/100?img=13',
                status: 'Inactive',
                statusColor: const Color(0xFF4B5563), // gray-600
                statusBgColor: const Color(0xFFF9FAFB), // gray-50
              ),
            ],
          ),
        ),
      ],
    );
  }
}
