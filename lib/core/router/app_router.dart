import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_providers.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_states.dart';
import 'package:hr_connect/features/auth/presentation/screens/login_screen.dart';
import 'package:hr_connect/features/auth/presentation/screens/register_screen.dart';
import 'package:hr_connect/features/base/presentation/screens/main_shell.dart';
import 'package:hr_connect/features/employee/presentation/screens/employee_list_screen.dart';
import 'package:hr_connect/features/home_dashboard/presentation/screens/dashboard_content.dart';
import 'package:hr_connect/features/profile/presentation/screens/profile_content.dart';
import 'package:hr_connect/features/settings/presentation/screens/settings_screen.dart';
import 'package:hr_connect/features/splash_screen/presentation/screens/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AppRouterNotifier(ref),
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/loading',
        name: 'loading',
        builder: (context, state) => const _LoadingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main shell with persistent drawer/header
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) {
              final authState = ref.read(authProvider);
              if (authState is AuthLoaded) {
                return NoTransitionPage(
                  child: DashboardContent(employee: authState.employee),
                );
              }
              return const NoTransitionPage(child: _LoadingScreen());
            },
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) {
              final authState = ref.read(authProvider);
              if (authState is AuthLoaded) {
                return NoTransitionPage(
                  child: ProfileContent(employee: authState.employee),
                );
              }
              return const NoTransitionPage(child: _LoadingScreen());
            },
          ),
          GoRoute(
            path: '/employees',
            name: 'employees',
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: EmployeeListScreen());
            },
          ),
          GoRoute(
            path: '/attendance',
            name: 'attendance',
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: AttendanceScreen());
            },
          ),
          GoRoute(
            path: '/leave-requests',
            name: 'leave-requests',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: _PlaceholderScreen(title: 'Leave Requests'),
              );
            },
          ),
          GoRoute(
            path: '/approvals',
            name: 'approvals',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: _PlaceholderScreen(title: 'Approvals'),
              );
            },
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) {
              return const NoTransitionPage(child: SettingsScreen());
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.uri.toString();
      final isAuthRoute = location == '/login' || location == '/register';
      final isSplash = location == '/splash';

      // Allow splash screen
      if (isSplash) return null;

      if (authState is AuthLoading || authState is AuthInitial) {
        return location == '/loading' ? null : '/loading';
      }

      if (authState is AuthLoaded) {
        // If coming from auth routes, go to dashboard
        if (isAuthRoute || isSplash || location == '/loading') {
          return '/dashboard';
        }
        return null;
      }

      if (authState is AuthUnauthenticated || authState is AuthError) {
        return isAuthRoute ? null : '/login';
      }

      return null;
    },
  );
});

class _AppRouterNotifier extends ChangeNotifier {
  _AppRouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
