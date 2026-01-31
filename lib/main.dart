import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/config/app_config.dart';
import 'package:hr_connect/core/router/app_router.dart';
import 'package:hr_connect/core/theme/app_theme.dart';

void main() {
  bootstrap(Flavor.development);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      builder: (context, child) {
        // Optional: Add a robust flavor banner for non-production environments
        if (!config.isProduction) {
          return Banner(
            message: config.flavor.name.toUpperCase(),
            location: BannerLocation.topStart,
            color: config.isDevelopment ? Colors.green : Colors.orange,
            child: child!,
          );
        }
        return child!;
      },
    );
  }
}
