import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // ==============================
  // App Information
  // ==============================

  static const String appName = 'The Map Project';

  // ==============================
  // Supabase
  // ==============================

  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL']!;

  static String get supabasePublishableKey =>
      dotenv.env['SUPABASE_ANON_KEY']!;

  // ==============================
  // MapTiler
  // ==============================

  static String get mapTilerApiKey =>
      dotenv.env['MAPTILER_API_KEY']!;

  // ==============================
  // Routing Backend
  // ==============================

  static String get routingBackendUrl =>
      dotenv.env['ROUTING_BACKEND_URL']!;

  // ==============================
  // Deep Link
  // ==============================

  static const String redirectUrl =
      'io.supabase.flutter://login-callback';
}