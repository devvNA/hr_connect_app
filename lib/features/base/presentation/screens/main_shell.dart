import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/theme/app_color.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_providers.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_states.dart';
import 'package:hr_connect/features/base/presentation/widgets/app_drawer.dart';
import 'package:hr_connect/features/base/presentation/widgets/app_header.dart';

/// Main shell screen that wraps all authenticated screens
/// Provides persistent Drawer and Header across all child routes
class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Guard: only show shell when authenticated
    if (authState is! AuthLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final employee = authState.employee;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: AppDrawer(employee: employee),
      appBar: AppHeader(
        employee: employee,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () {
          // TODO: Navigate to notifications
        },
      ),
      body: widget.child,
    );
  }
}
