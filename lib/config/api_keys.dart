/// ⚠️ ARCHIVO PRIVADO - NO SUBIR A GITHUB ⚠️
/// Este archivo contiene claves API sensibles y está protegido por .gitignore
///
/// Para configurar:
/// 1. Copia este archivo (ya está ignorado por git)
/// 2. Reemplaza 'TU_CLAVE_AQUI' con tu clave real de Google Gemini
/// 3. NUNCA compartas este archivo públicamente
library;

class ApiKeys {
  // Google Gemini API Key (Regenerada: 5 Nov 2025)
  // Obtén tu clave en: https://makersuite.google.com/app/apikey
  static const String geminiApiKey = 'AIzaSyDRrCJTvBAT59ytRWg3vreuuJplWu7YgTc';

  // Supabase Configuration
  // URL del proyecto: https://supabase.com/dashboard/project/awtvethqcigauaxyzqhz
  static const String supabaseUrl = 'https://awtvethqcigauaxyzqhz.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3dHZldGhxY2lnYXVheHl6cWh6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIyOTEwNzYsImV4cCI6MjA3Nzg2NzA3Nn0.6bTl_DGdWMmfNIpfQRzSZ7OPbBrjk2n52MatjPlgEDA';

  // Stripe Configuration
  // Dashboard: https://dashboard.stripe.com/test/apikeys
  static const String stripePublishableKey = 'pk_test_TU_CLAVE_PUBLICA_AQUI';

  // Validación (no modificar)
  static bool get isConfigured =>
      geminiApiKey != 'TU_CLAVE_AQUI' &&
      geminiApiKey.isNotEmpty &&
      supabaseUrl.isNotEmpty;
}
