import 'package:flutter/material.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

class ProfileInfoSection extends StatelessWidget {
  final String title;
  final Widget? action;
  final List<Widget> children;

  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.children,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}
