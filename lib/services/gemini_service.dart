import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/gemini_config.dart';
import '../models/nutritional_analysis.dart';

/// Servicio para interactuar con Google Gemini AI
/// y realizar análisis nutricional de imágenes de alimentos
class GeminiService {
  late final GenerativeModel _model;
  bool _initialized = false;

  GeminiService() {
    _initializeModel();
  }

  void _initializeModel() {
    try {
      _model = GenerativeModel(
        model: GeminiConfig.model,
        apiKey: GeminiConfig.apiKey,
        generationConfig: GenerationConfig(
          temperature: GeminiConfig.temperature,
          maxOutputTokens: GeminiConfig.maxOutputTokens,
        ),
      );
      _initialized = true;
      debugPrint('✅ Gemini AI inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error inicializando Gemini AI: $e');
      _initialized = false;
    }
  }

  /// Analiza una imagen de comida y retorna información nutricional
  Future<NutritionalAnalysis?> analyzeFood(File imageFile) async {
    if (!_initialized) {
      throw Exception('Gemini AI no está inicializado');
    }

    try {
      debugPrint('📸 Analizando imagen: ${imageFile.path}');

      // Leer la imagen como bytes (Uint8List)
      final imageBytes = await imageFile.readAsBytes();

      // Inferir el mimeType basado en la extensión del archivo
      final mimeType = _getMimeType(imageFile.path);
      debugPrint('🖼️ Tipo de archivo detectado: $mimeType');

      // Crear las partes del contenido multimodal
      final prompt = TextPart(GeminiConfig.nutritionalAnalysisPrompt);
      final imagePart = DataPart(mimeType, imageBytes);

      // Construir contenido multimodal
      final content = [
        Content.multi([prompt, imagePart])
      ];

      // Enviar a Gemini
      debugPrint('🤖 Enviando solicitud a Gemini AI...');
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        debugPrint('⚠️ Respuesta vacía de Gemini');
        throw Exception('No se recibió respuesta del análisis');
      }

      debugPrint('✅ Respuesta recibida de Gemini');
      debugPrint('📄 Respuesta: ${response.text}');

      // Parsear la respuesta JSON
      final analysis = _parseResponse(response.text!, imageFile.path);
      debugPrint('✅ Análisis nutricional completado: ${analysis.nombre}');

      return analysis;
    } catch (e, stackTrace) {
      debugPrint('❌ Error en análisis nutricional: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Inferir mimeType basado en la extensión del archivo
  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'heic':
      case 'heif':
        return 'image/heic';
      default:
        debugPrint(
            '⚠️ Extensión no reconocida: $extension, usando image/jpeg por defecto');
        return 'image/jpeg'; // Default seguro
    }
  }

  /// Parsea la respuesta de Gemini y crea un objeto NutritionalAnalysis
  NutritionalAnalysis _parseResponse(String responseText, String imagePath) {
    try {
      // Extraer el JSON de la respuesta (puede venir con markdown)
      String jsonText = responseText.trim();

      // Remover bloques de código markdown si existen
      if (jsonText.contains('```json')) {
        jsonText = jsonText
            .substring(jsonText.indexOf('```json') + 7)
            .substring(0, jsonText.lastIndexOf('```'))
            .trim();
      } else if (jsonText.contains('```')) {
        jsonText = jsonText
            .substring(jsonText.indexOf('```') + 3)
            .substring(0, jsonText.lastIndexOf('```'))
            .trim();
      }

      // Parsear JSON
      final Map<String, dynamic> jsonData = json.decode(jsonText);
      jsonData['image_path'] = imagePath;

      return NutritionalAnalysis.fromJson(jsonData);
    } catch (e) {
      debugPrint('❌ Error parseando respuesta: $e');
      debugPrint('Texto de respuesta: $responseText');

      // Retornar un análisis de error
      return NutritionalAnalysis(
        nombre: 'Error en análisis',
        porcionEstimada: 'N/A',
        calorias: 0,
        macronutrientes: Macronutrientes(
          proteinas: 0,
          carbohidratos: 0,
          grasas: 0,
          fibra: 0,
        ),
        micronutrientesDestacados: [],
        beneficios: [],
        recomendaciones:
            'No se pudo analizar la imagen correctamente. Intenta con otra foto más clara.',
        nivelSaludable: NivelSaludable.medio,
        aptoPara: [],
        fechaAnalisis: DateTime.now(),
        imagePath: imagePath,
      );
    }
  }

  /// Verifica si el servicio está inicializado
  bool get isInitialized => _initialized;
}
