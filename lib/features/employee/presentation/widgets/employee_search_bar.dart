import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

class EmployeeSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearch;

  const EmployeeSearchBar({super.key, this.onSearch});

  @override
  State<EmployeeSearchBar> createState() => _EmployeeSearchBarState();
}

class _EmployeeSearchBarState extends State<EmployeeSearchBar> {
  // ... (existing logic)
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch?.call(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.small,
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search name, role, or ID...',
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textLight),
          prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                ),
              IconButton(
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.textLight,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
