import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/utils/shimmering.dart';
import 'package:hr_connect/features/employee/presentation/providers/employee_providers.dart';
import 'package:hr_connect/features/employee/presentation/providers/employee_states.dart';

class FilterChipList extends ConsumerWidget {
  const FilterChipList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentState = ref.watch(departmentListProvider);

    return switch (departmentState) {
      DepartmentListLoading() => _buildShimmer(),
      DepartmentListError(message: final msg) => _buildError(msg, ref),
      DepartmentListLoaded(
        departments: final departments,
        selectedDepartmentId: final selectedId,
      ) =>
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // "All" chip
              _buildChip(
                context,
                label: 'All',
                isSelected: selectedId == null,
                onTap: () => ref
                    .read(departmentListProvider.notifier)
                    .selectDepartment(null),
              ),
              const SizedBox(width: 8),
              // Department chips from database
              ...departments.map(
                (dept) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildChip(
                    context,
                    label: dept.name,
                    isSelected: selectedId == dept.id,
                    onTap: () => ref
                        .read(departmentListProvider.notifier)
                        .selectDepartment(dept.id),
                  ),
                ),
              ),
            ],
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SkeletonShimmer(width: 80, height: 36, borderRadius: 8),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message, WidgetRef ref) {
    return Row(
      children: [
        const Icon(Icons.error_outline, color: AppColors.error, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () =>
              ref.read(departmentListProvider.notifier).loadDepartments(),
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
