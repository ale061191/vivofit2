import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/nutritional_analysis.dart';

/// Servicio de reconocimiento visual de alimentos usando Clarifai
/// Clarifai tiene un modelo específico para comida (food-item-recognition)
/// Plan gratuito: 5000 operaciones/mes
/// Documentación: https://docs.clarifai.com/
class ClarifaiService {
  // 🔑 CREDENCIALES DE CLARIFAI
  // Obtén tu API Key en: https://clarifai.com/settings/security
  static const String _apiKey = 'a6b67fd4bc3e435db1d6b9e278069d1f';
  static const String _userId = 'clarifai'; // Usuario por defecto
  static const String _appId = 'main'; // App por defecto

  // Modelo especializado en reconocimiento de comida
  static const String _foodModelId = 'food-item-recognition';
  static const String _baseUrl = 'https://api.clarifai.com/v2';

  bool _initialized = false;

  ClarifaiService() {
    _initialized = _apiKey != 'TU_CLARIFAI_API_KEY_AQUI' && _apiKey.isNotEmpty;
    if (_initialized) {
      debugPrint('✅ Clarifai inicializado correctamente');
    } else {
      debugPrint('⚠️ Clarifai no configurado. Configura tu API Key.');
    }
  }

  /// Analiza una imagen de comida y retorna los alimentos detectados
  Future<NutritionalAnalysis?> analyzeFood(File imageFile) async {
    if (!_initialized) {
      throw Exception('Clarifai no está configurado. Agrega tu API Key.');
    }

    try {
      debugPrint('📸 Analizando imagen con Clarifai: ${imageFile.path}');

      // Leer imagen como base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Llamar a Clarifai API
      final response = await http.post(
        Uri.parse('$_baseUrl/models/$_foodModelId/outputs'),
        headers: {
          'Authorization': 'Key $_apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_app_id': {
            'user_id': _userId,
            'app_id': _appId,
          },
          'inputs': [
            {
              'data': {
                'image': {
                  'base64': base64Image,
                }
              }
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseClarifaiResponse(data, imageFile.path);
      } else {
        debugPrint('❌ Error HTTP ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error en análisis Clarifai: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Parsea la respuesta de Clarifai
  NutritionalAnalysis _parseClarifaiResponse(
    Map<String, dynamic> data,
    String imagePath,
  ) {
    try {
      final outputs = data['outputs'] as List;
      if (outputs.isEmpty) {
        throw Exception('No se detectaron alimentos en la imagen');
      }

      final concepts =
          (outputs[0]['data']['concepts'] as List).cast<Map<String, dynamic>>();

      // Tomar los 3 alimentos con mayor confianza
      final topFoods = concepts.take(3).toList();
      final foodNames = topFoods.map((c) => c['name'] as String).join(', ');

      debugPrint('🍽️ Alimentos detectados: $foodNames');

      // Obtener datos nutricionales estimados
      final analysis = _estimateNutrition(topFoods);

      return analysis.copyWith(
        nombre: foodNames.isEmpty ? 'Alimento no identificado' : foodNames,
        imagePath: imagePath,
      );
    } catch (e) {
      debugPrint('❌ Error parseando respuesta Clarifai: $e');
      rethrow;
    }
  }

  /// Estima información nutricional basada en alimentos detectados
  NutritionalAnalysis _estimateNutrition(List<Map<String, dynamic>> foods) {
    // Base de datos simplificada de nutrición
    // En producción, esto vendría de una API como Nutritionix o Edamam
    final nutritionDb = _getFoodNutritionDatabase();

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;

    final beneficios = <String>[];
    final micronutrientes = <String>[];

    for (final food in foods) {
      final foodName = (food['name'] as String).toLowerCase();
      final confidence = (food['value'] as num).toDouble();

      // Buscar en base de datos (match aproximado)
      for (final entry in nutritionDb.entries) {
        if (foodName.contains(entry.key) || entry.key.contains(foodName)) {
          final nutrition = entry.value;
          // Ponderar por confianza
          totalCalories += nutrition['calories']! * confidence;
          totalProtein += nutrition['protein']! * confidence;
          totalCarbs += nutrition['carbs']! * confidence;
          totalFat += nutrition['fat']! * confidence;
          totalFiber += nutrition['fiber']! * confidence;

          // Agregar beneficios
          if (nutrition['benefits'] != null) {
            beneficios.addAll((nutrition['benefits'] as List).cast<String>());
          }
          if (nutrition['micronutrients'] != null) {
            micronutrientes
                .addAll((nutrition['micronutrients'] as List).cast<String>());
          }
          break;
        }
      }
    }

    // Determinar nivel saludable
    final nivelSaludable = _determineHealthLevel(
      totalCalories,
      totalProtein,
      totalFat,
    );

    return NutritionalAnalysis(
      nombre: '', // Se llenará fuera
      porcionEstimada: '1 porción estimada',
      calorias: totalCalories.round(),
      macronutrientes: Macronutrientes(
        proteinas: totalProtein,
        carbohidratos: totalCarbs,
        grasas: totalFat,
        fibra: totalFiber,
      ),
      micronutrientesDestacados: micronutrientes.toSet().toList(),
      beneficios: beneficios.toSet().take(3).toList(),
      recomendaciones: _generateRecommendations(totalCalories, totalProtein),
      nivelSaludable: nivelSaludable,
      aptoPara: [], // Se puede agregar lógica para dietas específicas
      fechaAnalisis: DateTime.now(),
      imagePath: '', // Se llenará fuera
    );
  }

  NivelSaludable _determineHealthLevel(
    double calories,
    double protein,
    double fat,
  ) {
    int score = 0;

    // Criterios saludables
    if (calories < 500) score++;
    if (protein > 20) score++;
    if (fat < 15) score++;

    if (score >= 2) return NivelSaludable.alto;
    if (score == 1) return NivelSaludable.medio;
    return NivelSaludable.bajo;
  }

  String _generateRecommendations(double calories, double protein) {
    if (calories > 600) {
      return 'Porción alta en calorías. Considera dividirla en dos comidas o complementar con ejercicio.';
    }
    if (protein < 15) {
      return 'Bajo en proteínas. Considera agregar pollo, pescado, huevos o legumbres.';
    }
    return 'Alimento balanceado. Disfrútalo como parte de una dieta variada.';
  }

  /// Base de datos simplificada de nutrición por 100g
  /// En producción, usa una API real como Edamam o Nutritionix
  Map<String, Map<String, dynamic>> _getFoodNutritionDatabase() {
    return {
      'chicken': {
        'calories': 165.0,
        'protein': 31.0,
        'carbs': 0.0,
        'fat': 3.6,
        'fiber': 0.0,
        'benefits': ['Alto en proteínas', 'Bajo en grasas'],
        'micronutrients': ['Vitamina B6', 'Niacina'],
      },
      'rice': {
        'calories': 130.0,
        'protein': 2.7,
        'carbs': 28.0,
        'fat': 0.3,
        'fiber': 0.4,
        'benefits': ['Fuente de energía', 'Sin gluten'],
        'micronutrients': ['Magnesio', 'Hierro'],
      },
      'broccoli': {
        'calories': 34.0,
        'protein': 2.8,
        'carbs': 7.0,
        'fat': 0.4,
        'fiber': 2.6,
        'benefits': ['Alto en fibra', 'Rico en vitaminas'],
        'micronutrients': ['Vitamina C', 'Vitamina K', 'Calcio'],
      },
      'egg': {
        'calories': 155.0,
        'protein': 13.0,
        'carbs': 1.1,
        'fat': 11.0,
        'fiber': 0.0,
        'benefits': ['Proteína completa', 'Rico en nutrientes'],
        'micronutrients': ['Vitamina B12', 'Colina'],
      },
      'banana': {
        'calories': 89.0,
        'protein': 1.1,
        'carbs': 23.0,
        'fat': 0.3,
        'fiber': 2.6,
        'benefits': ['Rico en potasio', 'Energía rápida'],
        'micronutrients': ['Potasio', 'Vitamina B6'],
      },
      'salmon': {
        'calories': 208.0,
        'protein': 20.0,
        'carbs': 0.0,
        'fat': 13.0,
        'fiber': 0.0,
        'benefits': ['Omega-3', 'Alto en proteínas'],
        'micronutrients': ['Vitamina D', 'Selenio'],
      },
    };
  }
}
