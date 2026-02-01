import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/settings/presentation/widgets/logout_button.dart';
import 'package:hr_connect/features/settings/presentation/widgets/settings_section.dart';
import 'package:hr_connect/features/settings/presentation/widgets/settings_tile.dart';
import 'package:hr_connect/features/settings/presentation/widgets/settings_toggle_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local state for toggles (mocking functionality)
  bool _is2FAEnabled = true;
  bool _isPushNotificationsEnabled = true;
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Account Section
          SettingsSection(
            title: 'Account',
            children: [
              SettingsTile(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () {
                  context.go('/profile');
                },
              ),
              SettingsTile(
                icon: Icons.lock,
                title: 'Change Password',
                onTap: () {},
              ),
              SettingsToggleTile(
                icon: Icons.security,
                title: 'Two-Factor Auth',
                subtitle: 'Extra security for your account',
                value: _is2FAEnabled,
                onChanged: (value) {
                  setState(() => _is2FAEnabled = value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Preferences Section
          SettingsSection(
            title: 'Preferences',
            children: [
              SettingsToggleTile(
                icon: Icons.notifications,
                title: 'Push Notifications',
                value: _isPushNotificationsEnabled,
                onChanged: (value) {
                  setState(() => _isPushNotificationsEnabled = value);
                },
              ),
              SettingsTile(
                icon: Icons.language,
                title: 'Language',
                valueLabel: 'English (US)',
                onTap: () {},
              ),
              SettingsToggleTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                value: _isDarkModeEnabled,
                onChanged: (value) {
                  setState(() => _isDarkModeEnabled = value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Company Section (Admin View Mockup)
          SettingsSection(
            title: 'Company',
            children: [
              SettingsTile(
                icon: Icons.badge,
                title: 'Directory Settings',
                subtitle: 'Manage employee visibility',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.payments,
                title: 'Payroll Configuration',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),

          // Logout Button
          const LogoutButton(),
          const SizedBox(height: AppSpacing.xxl),

          // Version Info
          Text(
            'HRIS App v2.4.1 (Build 8902)',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
