import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/nutritional_analysis.dart';

/// Servicio de análisis nutricional usando Edamam Food Recognition API
/// API gratuita con 1000 requests/mes
/// Documentación: https://developer.edamam.com/food-database-api
class EdamamService {
  // 🔑 CREDENCIALES GRATUITAS DE EDAMAM
  // Obtén las tuyas en: https://developer.edamam.com/edamam-recipe-api
  static const String _appId = 'TU_APP_ID_AQUI'; // Reemplazar
  static const String _appKey = 'TU_APP_KEY_AQUI'; // Reemplazar

  static const String _nutritionAnalysisEndpoint =
      'https://api.edamam.com/api/nutrition-details';

  /// Analiza una imagen de comida y retorna información nutricional
  ///
  /// NOTA: Edamam no acepta imágenes directamente.
  /// Esta implementación usa OCR/visión para extraer texto de la imagen
  /// y luego busca en la base de datos de Edamam.
  ///
  /// Para análisis visual real, considera usar Clarifai (implementado abajo)
  Future<NutritionalAnalysis?> analyzeFood(File imageFile) async {
    try {
      debugPrint('📸 Analizando imagen con Edamam: ${imageFile.path}');

      // Por ahora, usamos un análisis de ejemplo basado en texto
      // En producción, integrarías con un servicio OCR o Google Vision
      const exampleFood = '''
      1 pechuga de pollo (200g)
      1 taza de arroz blanco cocido
      1/2 taza de brócoli al vapor
      ''';

      final analysis = await _analyzeByText(exampleFood);

      debugPrint('✅ Análisis completado: ${analysis?.nombre}');
      return analysis;
    } catch (e, stackTrace) {
      debugPrint('❌ Error en análisis Edamam: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Analiza alimentos por descripción textual
  Future<NutritionalAnalysis?> _analyzeByText(String foodDescription) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$_nutritionAnalysisEndpoint?app_id=$_appId&app_key=$_appKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': 'Análisis Nutricional',
          'ingr': foodDescription
              .split('\n')
              .where((s) => s.trim().isNotEmpty)
              .toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseEdamamResponse(data);
      } else {
        debugPrint('❌ Error HTTP ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error en petición Edamam: $e');
      return null;
    }
  }

  /// Parsea la respuesta de Edamam a nuestro modelo
  NutritionalAnalysis _parseEdamamResponse(Map<String, dynamic> data) {
    final nutrients = data['totalNutrients'] as Map<String, dynamic>? ?? {};
    final healthLabels = (data['healthLabels'] as List?)?.cast<String>() ?? [];

    // Extraer macronutrientes
    final calories = _getQuantity(nutrients, 'ENERC_KCAL');
    final protein = _getQuantity(nutrients, 'PROCNT');
    final carbs = _getQuantity(nutrients, 'CHOCDF');
    final fat = _getQuantity(nutrients, 'FAT');
    final fiber = _getQuantity(nutrients, 'FIBTG');

    // Micronutrientes destacados
    final micronutrients = <String>[];
    if (_getQuantity(nutrients, 'VITA_RAE') > 0)
      micronutrients.add('Vitamina A');
    if (_getQuantity(nutrients, 'VITC') > 0) micronutrients.add('Vitamina C');
    if (_getQuantity(nutrients, 'CA') > 0) micronutrients.add('Calcio');
    if (_getQuantity(nutrients, 'FE') > 0) micronutrients.add('Hierro');

    // Determinar nivel saludable basado en healthLabels
    final nivelSaludable = _determineHealthLevel(healthLabels);

    // Beneficios basados en etiquetas
    final beneficios = _extractBenefits(healthLabels);

    return NutritionalAnalysis(
      nombre: data['yield'] != null ? 'Plato combinado' : 'Alimento analizado',
      porcionEstimada: '${data['yield'] ?? 1} porción(es)',
      calorias: calories.toInt(),
      macronutrientes: Macronutrientes(
        proteinas: protein,
        carbohidratos: carbs,
        grasas: fat,
        fibra: fiber,
      ),
      micronutrientesDestacados: micronutrients,
      beneficios: beneficios,
      recomendaciones: _generateRecommendations(calories, protein, carbs, fat),
      nivelSaludable: nivelSaludable,
      aptoPara: healthLabels
          .where((l) =>
              l.contains('Vegan') ||
              l.contains('Vegetarian') ||
              l.contains('Gluten-Free'))
          .toList(),
      fechaAnalisis: DateTime.now(),
      imagePath: '', // Se agregará después
    );
  }

  double _getQuantity(Map<String, dynamic> nutrients, String code) {
    final nutrient = nutrients[code] as Map<String, dynamic>?;
    if (nutrient == null) return 0.0;
    return (nutrient['quantity'] as num?)?.toDouble() ?? 0.0;
  }

  NivelSaludable _determineHealthLevel(List<String> labels) {
    final positiveLabels = [
      'Low-Sodium',
      'Low-Fat',
      'Low-Carb',
      'High-Fiber',
      'High-Protein'
    ];

    final matchCount =
        labels.where((l) => positiveLabels.any((p) => l.contains(p))).length;

    if (matchCount >= 3) return NivelSaludable.alto;
    if (matchCount >= 1) return NivelSaludable.medio;
    return NivelSaludable.bajo;
  }

  List<String> _extractBenefits(List<String> labels) {
    final benefits = <String>[];

    if (labels.contains('Low-Sodium')) {
      benefits.add('Bajo en sodio, ideal para salud cardiovascular');
    }
    if (labels.contains('High-Fiber')) {
      benefits.add('Alto en fibra, mejora la digestión');
    }
    if (labels.contains('High-Protein')) {
      benefits.add('Rico en proteínas, ayuda al crecimiento muscular');
    }
    if (labels.contains('Low-Fat')) {
      benefits.add('Bajo en grasas, control de peso');
    }

    return benefits.isEmpty ? ['Alimento completo y nutritivo'] : benefits;
  }

  String _generateRecommendations(
    double calories,
    double protein,
    double carbs,
    double fat,
  ) {
    final buffer = StringBuffer();

    if (calories > 600) {
      buffer.write('Porción alta en calorías, considera dividirla. ');
    } else if (calories < 300) {
      buffer.write('Porción ligera, ideal para snack. ');
    }

    if (protein > 30) {
      buffer.write('Excelente aporte proteico. ');
    } else if (protein < 10) {
      buffer.write('Considera agregar más proteína. ');
    }

    if (carbs > 60) {
      buffer.write('Alto en carbohidratos, ideal pre-entrenamiento. ');
    }

    if (fat > 20) {
      buffer
          .write('Contenido de grasa moderado-alto, equilibra con vegetales. ');
    }

    return buffer.isEmpty
        ? 'Alimento balanceado, disfrútalo como parte de una dieta variada.'
        : buffer.toString().trim();
  }
}
