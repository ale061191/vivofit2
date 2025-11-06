/// ⚠️ ARCHIVO PRIVADO - NO SUBIR A GITHUB ⚠️
/// Este archivo contiene claves API sensibles y está protegido por .gitignore
///
/// Para configurar:
/// 1. Copia este archivo (ya está ignorado por git)
/// 2. Reemplaza 'TU_CLAVE_AQUI' con tu clave real de Google Gemini
/// 3. NUNCA compartas este archivo públicamente
library;

class ApiKeys {
  // Google Gemini API Key
  // ⚠️ PLACEHOLDER para GitHub Actions - Configura tus claves reales localmente
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyDRrCJTvBAT59ytRWg3vreuuJplWu7YgTc', // Tu clave real para desarrollo local
  );

  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://awtvethqcigauaxyzqhz.supabase.co', // Tu URL real para desarrollo local
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3dHZldGhxY2lnYXVheHl6cWh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyOTEwNzYsImV4cCI6MjA3Nzg2NzA3Nn0.6bTl_DGdWMmfNIpfQRzSZ7OPbBrjk2n52MatjPlgEDA', // Tu key real para desarrollo local
  );

  // Validación
  static bool get isConfigured =>
      geminiApiKey.isNotEmpty &&
      supabaseUrl.isNotEmpty;
}
