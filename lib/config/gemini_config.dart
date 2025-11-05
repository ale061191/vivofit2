/// Configuración de Google Gemini AI
/// IMPORTANTE: Esta API Key debe mantenerse privada y segura
class GeminiConfig {
  // TODO: Antes de entregar al cliente, eliminar esta API Key
  // y usar variables de entorno o configuración externa
  static const String apiKey = 'AIzaSyBYXhvyrQflZUkaFTdgPTmOaslA4rWiWRo';

  // Modelo a utilizar para análisis nutricional
  static const String model = 'gemini-1.5-flash';

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
