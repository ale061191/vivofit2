import 'api_keys.dart';

/// Configuración de Supabase
/// ✅ SEGURIDAD: Las credenciales ahora se cargan desde api_keys.dart
/// que está protegido por .gitignore y NO se sube a GitHub
class SupabaseConfig {
  /// URL del proyecto Supabase (desde api_keys.dart)
  static String get supabaseUrl => ApiKeys.supabaseUrl;

  /// Anon Key - clave pública (desde api_keys.dart)
  static String get supabaseAnonKey => ApiKeys.supabaseAnonKey;

  // Nombres de tablas
  static const String usersTable = 'users';
  static const String workoutSessionsTable = 'workout_sessions';
  static const String nutritionalAnalysesTable = 'nutritional_analyses';
  static const String bmiHistoryTable = 'bmi_history';
  static const String membershipsTable = 'memberships';

  // Storage buckets
  static const String profilePhotosBucket = 'profile-photos';
  static const String foodPhotosBucket = 'food-photos';
}
