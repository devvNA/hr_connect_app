import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Flavor { development, production }

class AppConfig {
  final String appName;
  final Flavor flavor;
  final bool isDevelopment;
  final String supabaseUrl;
  final String supabaseAnonKey;

  AppConfig({
    required this.appName,
    required this.flavor,
    required this.isDevelopment,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  bool get isProduction => flavor == Flavor.production;
}

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig must be overridden in main.dart');
});
