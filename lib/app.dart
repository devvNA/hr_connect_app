import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/config/app_config.dart';
import 'package:hr_connect/core/utils/date_formatter.dart';
import 'package:hr_connect/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // Note: Using the same .env for all flavors as requested,
  // but typically you might use .env.dev, .env.prod, etc.
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception('SUPABASE_URL or SUPABASE_ANON_KEY not found in .env');
  }

  AppConfig config;
  switch (flavor) {
    case Flavor.development:
      config = AppConfig(
        appName: 'HR Connect (Dev)',
        flavor: flavor,
        isDevelopment: true,
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
      );
      break;
    case Flavor.production:
      config = AppConfig(
        appName: 'HR Connect',
        flavor: flavor,
        isDevelopment: false,
        supabaseUrl: supabaseUrl,
        supabaseAnonKey: supabaseAnonKey,
      );
      break;
  }

  await Future.wait([
    DateFormatter.initialize(),
    Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
    ),
  ]);

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const MyApp(),
    ),
  );
}
