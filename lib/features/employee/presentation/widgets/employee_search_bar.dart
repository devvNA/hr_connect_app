import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';

class EmployeeSearchBar extends StatelessWidget {
  const EmployeeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.shadowSoft,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search name, role, or ID...',
          hintStyle: const TextStyle(color: AppColors.textLight),
          prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textLight, size: 20),
            onPressed: () {},
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
