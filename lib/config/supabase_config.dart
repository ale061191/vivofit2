/// Configuración de Supabase
/// IMPORTANTE: Estas credenciales deben mantenerse privadas y seguras
class SupabaseConfig {
  // TODO: Antes de entregar al cliente, mover estas credenciales
  // a variables de entorno o configuración externa

  /// URL del proyecto Supabase
  static const String supabaseUrl = 'https://awtvethqcigauaxyzqhz.supabase.co';

  /// Anon Key (clave pública)
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3dHZldGhxY2lnYXVheHl6cWh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyOTEwNzYsImV4cCI6MjA3Nzg2NzA3Nn0.6bTl_DGdWMmfNIpfQRzSZ7OPbBrjk2n52MatjPlgEDA';

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
