import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_providers.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_states.dart';
import 'package:hr_connect/features/auth/presentation/screens/login_screen.dart';
import 'package:hr_connect/features/auth/presentation/screens/register_screen.dart';
import 'package:hr_connect/features/home_dashboard/presentation/screens/home_screen.dart';
import 'package:hr_connect/features/profile/presentation/screens/profile_screen.dart';
import 'package:hr_connect/features/splash_screen/presentation/screens/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: _AppRouterNotifier(ref),
    routes: [
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
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          final authState = ref.read(authProvider);
          if (authState is AuthLoaded) {
            return HomeScreen(employee: authState.employee);
          }
          return const _LoadingScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          final authState = ref.read(authProvider);
          if (authState is AuthLoaded) {
            return ProfileScreen(employee: authState.employee);
          }
          return const _LoadingScreen();
        },
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.uri.toString();
      final isAuthRoute = location == '/login' || location == '/register';
      final isSplash = location == '/splash';

      // Allow splash screen to be displayed without redirect
      if (isSplash) {
        return null;
      }

      if (authState is AuthLoading || authState is AuthInitial) {
        return location == '/loading' ? null : '/loading';
      }

      if (authState is AuthLoaded) {
        // If coming from login/register/splash, go to home
        if (isAuthRoute || isSplash || location == '/loading') {
          return '/home';
        }
        // Otherwise allow the navigation (e.g. /profile)
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
