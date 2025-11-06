import 'api_keys.dart';

/// Configuración de Google Gemini AI
///
/// ✅ SEGURIDAD: La API Key ahora se carga desde un archivo privado (api_keys.dart)
/// que está protegido por .gitignore y NO se sube a GitHub
///
/// Para configurar:
/// 1. Copia api_keys.example.dart y renómbralo a api_keys.dart
/// 2. Agrega tu clave real de Gemini en api_keys.dart
class GeminiConfig {
  // La API Key se carga desde el archivo privado api_keys.dart
  static String get apiKey {
    if (!ApiKeys.isConfigured) {
      throw Exception('⚠️ API Key no configurada. '
          'Por favor copia api_keys.example.dart a api_keys.dart '
          'y configura tu clave de Google Gemini.');
    }
    return ApiKeys.geminiApiKey;
  }

  // Modelo a utilizar para análisis nutricional
  // gemini-pro-vision es el modelo específico para análisis de imágenes
  // Referencia: https://ai.google.dev/gemini-api/docs/models/gemini
  static const String model = 'gemini-pro-vision';

  // Configuración de seguridad
  static const int maxOutputTokens = 2048;
  static const double temperature = 0.4;

  // Prompt base para análisis nutricional
  static const String nutritionalAnalysisPrompt = '''
Analiza esta imagen de comida y proporciona la siguiente información en formato JSON:

{
  "nombre": "Nombre del alimento o plato",
  "porcion_estimada": "Tamaño de la porción (ej: 1 taza, 200g)",
  "calorias": número de calorías aproximadas,
  "macronutrientes": {
    "proteinas": gramos,
    "carbohidratos": gramos,
    "grasas": gramos,
    "fibra": gramos
  },
  "micronutrientes_destacados": ["vitamina C", "hierro", "calcio"],
  "beneficios": ["beneficio 1", "beneficio 2", "beneficio 3"],
  "recomendaciones": "Recomendaciones para consumo saludable",
  "nivel_saludable": "bajo/medio/alto",
  "apto_para": ["vegetarianos", "veganos", "celíacos", "etc"]
}

Si no puedes identificar claramente el alimento, indica "No se puede identificar claramente" en el campo nombre.
Sé preciso y realista en las estimaciones.
''';
}
