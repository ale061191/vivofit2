/// 📋 ARCHIVO DE EJEMPLO - Configuración de Claves API
///
/// ⚠️ INSTRUCCIONES PARA DESARROLLADORES:
///
/// 1. Copia este archivo y renómbralo a: api_keys.dart
/// 2. Reemplaza 'TU_CLAVE_AQUI' con tus claves reales
/// 3. El archivo api_keys.dart está protegido por .gitignore (no se subirá a GitHub)
///
/// IMPORTANTE: NUNCA subas tus claves reales a GitHub o repositorios públicos

class ApiKeys {
  // Google Gemini API Key
  // Obtén tu clave en: https://makersuite.google.com/app/apikey
  //
  // Pasos para obtener tu clave:
  // 1. Ve a https://makersuite.google.com/app/apikey
  // 2. Inicia sesión con tu cuenta de Google
  // 3. Crea un nuevo proyecto o selecciona uno existente
  // 4. Genera una nueva API Key
  // 5. Copia la clave y pégala aquí (reemplazando 'TU_CLAVE_AQUI')
  // 6. Configura restricciones de API para mayor seguridad
  static const String geminiApiKey = 'TU_CLAVE_AQUI';

  // Validación (no modificar)
  static bool get isConfigured => geminiApiKey != 'TU_CLAVE_AQUI';
}
