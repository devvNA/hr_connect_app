import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/theme/app_theme.dart';
import 'package:hr_connect/features/auth/domain/entities/employee_entity.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_providers.dart';
import 'package:hr_connect/features/auth/presentation/providers/auth_states.dart';
import 'package:hr_connect/features/auth/presentation/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/utils/date_formatter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Future.wait([
    DateFormatter.initialize(),
    Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    ),
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'HR Connect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

/// Wrapper that handles auth state and navigation
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return switch (authState) {
      AuthLoading() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AuthLoaded(employee: final employee) => HomeScreen(employee: employee),
      AuthInitial() ||
      AuthUnauthenticated() ||
      AuthError() => const LoginScreen(),
    };
  }
}

/// Temporary home screen after login
class HomeScreen extends ConsumerWidget {
  final EmployeeEntity employee;

  const HomeScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HR Connect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  employee.fullName.isNotEmpty
                      ? employee.fullName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Selamat datang,',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                employee.fullName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  employee.id,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                employee.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              if (employee.jobTitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  employee.jobTitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
