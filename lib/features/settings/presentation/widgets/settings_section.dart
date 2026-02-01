import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgRadius,
            boxShadow: AppShadows.card,
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: _buildChildrenWithDividers(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    final List<Widget> items = [];
    for (int i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(
          const Divider(
            height: 1,
            thickness: 1,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
            color: AppColors.border,
          ),
        );
      }
    }
    return items;
  }
}
