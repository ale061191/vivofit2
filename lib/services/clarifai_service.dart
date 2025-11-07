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
      final foodName = (food['name'] as String).toLowerCase().trim();
      final confidence = (food['value'] as num).toDouble();

      debugPrint(
          '🔍 Buscando nutrición para: "$foodName" (confianza: ${(confidence * 100).toStringAsFixed(1)}%)');

      // Buscar coincidencia exacta o parcial en base de datos
      Map<String, dynamic>? matchedNutrition;
      String? matchedKey;

      // Primero: coincidencia exacta
      if (nutritionDb.containsKey(foodName)) {
        matchedNutrition = nutritionDb[foodName];
        matchedKey = foodName;
        debugPrint('✅ Coincidencia exacta: $matchedKey');
      } else {
        // Segundo: coincidencia parcial (buscar si el nombre contiene alguna palabra clave)
        for (final entry in nutritionDb.entries) {
          final key = entry.key;
          // Si el nombre detectado contiene la palabra clave O viceversa
          if (foodName.contains(key) || key.contains(foodName)) {
            matchedNutrition = entry.value;
            matchedKey = key;
            debugPrint('✅ Coincidencia parcial: "$foodName" → $matchedKey');
            break;
          }
        }
      }

      // Si encontramos coincidencia, sumar valores nutricionales
      if (matchedNutrition != null) {
        // Ponderar por confianza de detección
        final weight =
            confidence > 0.5 ? confidence : 0.5; // Mínimo 50% de peso

        totalCalories += matchedNutrition['calories']! * weight;
        totalProtein += matchedNutrition['protein']! * weight;
        totalCarbs += matchedNutrition['carbs']! * weight;
        totalFat += matchedNutrition['fat']! * weight;
        totalFiber += matchedNutrition['fiber']! * weight;

        debugPrint(
            '📊 Sumado: ${matchedNutrition['calories']} kcal × $weight = ${(matchedNutrition['calories']! * weight).toStringAsFixed(1)} kcal');

        // Agregar beneficios únicos
        if (matchedNutrition['benefits'] != null) {
          beneficios
              .addAll((matchedNutrition['benefits'] as List).cast<String>());
        }
        if (matchedNutrition['micronutrients'] != null) {
          micronutrientes.addAll(
              (matchedNutrition['micronutrients'] as List).cast<String>());
        }
      } else {
        debugPrint(
            '⚠️ No se encontró nutrición para: "$foodName" - usando valores genéricos');
        // Valores genéricos si no encontramos el alimento
        totalCalories += 150.0 * confidence;
        totalProtein += 8.0 * confidence;
        totalCarbs += 20.0 * confidence;
        totalFat += 5.0 * confidence;
        totalFiber += 2.0 * confidence;
      }
    }

    debugPrint(
        '📈 Total calculado: ${totalCalories.toStringAsFixed(1)} kcal, ${totalProtein.toStringAsFixed(1)}g proteína');

    // Determinar nivel saludable
    final nivelSaludable = _determineHealthLevel(
      totalCalories,
      totalProtein,
      totalFat,
      totalCarbs,
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
      recomendaciones: _generateRecommendations(
        totalCalories,
        totalProtein,
        totalFat,
        totalCarbs,
      ),
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
    double carbs,
  ) {
    int score = 0;

    // Criterios saludables
    if (calories < 400)
      score += 2;
    else if (calories < 600) score++;

    if (protein > 20)
      score += 2;
    else if (protein > 12) score++;

    if (fat < 10)
      score += 2;
    else if (fat < 20) score++;

    // Penalizaciones
    if (fat > 30) score -= 2; // Alto en grasas
    if (calories > 700) score -= 2; // Muy alto en calorías
    if (carbs > 60 && protein < 10) score--; // Alto en carbs y bajo en proteína

    if (score >= 4) return NivelSaludable.alto;
    if (score >= 1) return NivelSaludable.medio;
    return NivelSaludable.bajo;
  }

  String _generateRecommendations(
    double calories,
    double protein,
    double fat,
    double carbs,
  ) {
    // Comidas muy poco saludables (alto en grasas y calorías)
    if (fat > 30 && calories > 500) {
      return '⚠️ ATENCIÓN: Comida muy alta en grasas (${fat.toStringAsFixed(1)}g) y calorías. '
          'Este tipo de alimentos (hamburguesas, pizzas, fritos) deben consumirse ocasionalmente. '
          'Considera opciones más saludables o reduce el tamaño de la porción.';
    }

    // Alto en grasas
    if (fat > 25) {
      return '⚠️ Alto contenido de grasas (${fat.toStringAsFixed(1)}g). '
          'Limita el consumo de este tipo de alimentos. '
          'Complementa con vegetales y agua.';
    }

    // Alto en calorías
    if (calories > 600) {
      return '⚠️ Porción alta en calorías (${calories.round()} kcal). '
          'Considera dividirla en dos comidas o complementar con ejercicio cardiovascular.';
    }

    // Bajo en proteínas
    if (protein < 10 && calories > 300) {
      return 'Bajo en proteínas (${protein.toStringAsFixed(1)}g). '
          'Considera agregar pollo, pescado, huevos o legumbres para mayor saciedad.';
    }

    // Alto en carbohidratos simples
    if (carbs > 50 && fat > 20) {
      return 'Combinación alta en carbohidratos y grasas. '
          'Consume con moderación y balancea con proteínas magras.';
    }

    // Comida balanceada
    if (protein > 20 && fat < 15 && calories < 500) {
      return '✅ Excelente elección. Alimento balanceado y nutritivo. '
          'Mantén este tipo de opciones en tu dieta regular.';
    }

    // Default
    return 'Alimento aceptable. Disfrútalo con moderación como parte de una dieta variada y balanceada.';
  }

  /// Base de datos expandida de nutrición por 100g
  /// Datos aproximados para demostración - En producción usa API real
  Map<String, Map<String, dynamic>> _getFoodNutritionDatabase() {
    return {
      // CARNES Y PROTEÍNAS
      'chicken': {
        'calories': 165.0,
        'protein': 31.0,
        'carbs': 0.0,
        'fat': 3.6,
        'fiber': 0.0,
        'benefits': ['Alto en proteínas', 'Bajo en grasas'],
        'micronutrients': ['Vitamina B6', 'Niacina'],
      },
      'beef': {
        'calories': 250.0,
        'protein': 26.0,
        'carbs': 0.0,
        'fat': 15.0,
        'fiber': 0.0,
        'benefits': ['Alto en proteínas', 'Rico en hierro'],
        'micronutrients': ['Hierro', 'Zinc', 'Vitamina B12'],
      },
      'pork': {
        'calories': 242.0,
        'protein': 27.0,
        'carbs': 0.0,
        'fat': 14.0,
        'fiber': 0.0,
        'benefits': ['Fuente de proteínas', 'Rico en tiamina'],
        'micronutrients': ['Tiamina', 'Selenio'],
      },
      'bacon': {
        'calories': 541.0,
        'protein': 37.0,
        'carbs': 1.4,
        'fat': 42.0,
        'fiber': 0.0,
        'benefits': ['Alto en proteínas'],
        'micronutrients': ['Selenio', 'Fósforo'],
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
      'egg': {
        'calories': 155.0,
        'protein': 13.0,
        'carbs': 1.1,
        'fat': 11.0,
        'fiber': 0.0,
        'benefits': ['Proteína completa', 'Rico en nutrientes'],
        'micronutrients': ['Vitamina B12', 'Colina'],
      },

      // LÁCTEOS
      'cheese': {
        'calories': 402.0,
        'protein': 25.0,
        'carbs': 1.3,
        'fat': 33.0,
        'fiber': 0.0,
        'benefits': ['Alto en calcio', 'Fuente de proteínas'],
        'micronutrients': ['Calcio', 'Vitamina A', 'Fósforo'],
      },
      'milk': {
        'calories': 61.0,
        'protein': 3.2,
        'carbs': 4.8,
        'fat': 3.3,
        'fiber': 0.0,
        'benefits': ['Rico en calcio', 'Fuente de vitamina D'],
        'micronutrients': ['Calcio', 'Vitamina D'],
      },
      'yogurt': {
        'calories': 59.0,
        'protein': 10.0,
        'carbs': 3.6,
        'fat': 0.4,
        'fiber': 0.0,
        'benefits': ['Probióticos', 'Alto en proteínas'],
        'micronutrients': ['Calcio', 'Vitamina B12'],
      },
      'butter': {
        'calories': 717.0,
        'protein': 0.9,
        'carbs': 0.1,
        'fat': 81.0,
        'fiber': 0.0,
        'benefits': ['Fuente de vitamina A'],
        'micronutrients': ['Vitamina A', 'Vitamina E'],
      },

      // CEREALES Y GRANOS
      'rice': {
        'calories': 130.0,
        'protein': 2.7,
        'carbs': 28.0,
        'fat': 0.3,
        'fiber': 0.4,
        'benefits': ['Fuente de energía', 'Sin gluten'],
        'micronutrients': ['Magnesio', 'Hierro'],
      },
      'bread': {
        'calories': 265.0,
        'protein': 9.0,
        'carbs': 49.0,
        'fat': 3.2,
        'fiber': 2.7,
        'benefits': ['Fuente de carbohidratos'],
        'micronutrients': ['Hierro', 'Vitamina B1'],
      },
      'pasta': {
        'calories': 131.0,
        'protein': 5.0,
        'carbs': 25.0,
        'fat': 1.1,
        'fiber': 1.8,
        'benefits': ['Energía sostenida'],
        'micronutrients': ['Hierro', 'Magnesio'],
      },
      'oats': {
        'calories': 389.0,
        'protein': 16.9,
        'carbs': 66.0,
        'fat': 6.9,
        'fiber': 10.6,
        'benefits': ['Alto en fibra', 'Reduce colesterol'],
        'micronutrients': ['Manganeso', 'Fósforo'],
      },

      // FRUTAS
      'banana': {
        'calories': 89.0,
        'protein': 1.1,
        'carbs': 23.0,
        'fat': 0.3,
        'fiber': 2.6,
        'benefits': ['Rico en potasio', 'Energía rápida'],
        'micronutrients': ['Potasio', 'Vitamina B6'],
      },
      'apple': {
        'calories': 52.0,
        'protein': 0.3,
        'carbs': 14.0,
        'fat': 0.2,
        'fiber': 2.4,
        'benefits': ['Alto en fibra', 'Antioxidantes'],
        'micronutrients': ['Vitamina C', 'Potasio'],
      },
      'orange': {
        'calories': 47.0,
        'protein': 0.9,
        'carbs': 12.0,
        'fat': 0.1,
        'fiber': 2.4,
        'benefits': ['Rico en vitamina C'],
        'micronutrients': ['Vitamina C', 'Folato'],
      },
      'strawberry': {
        'calories': 32.0,
        'protein': 0.7,
        'carbs': 7.7,
        'fat': 0.3,
        'fiber': 2.0,
        'benefits': ['Antioxidantes', 'Bajo en calorías'],
        'micronutrients': ['Vitamina C', 'Manganeso'],
      },

      // VEGETALES
      'broccoli': {
        'calories': 34.0,
        'protein': 2.8,
        'carbs': 7.0,
        'fat': 0.4,
        'fiber': 2.6,
        'benefits': ['Alto en fibra', 'Rico en vitaminas'],
        'micronutrients': ['Vitamina C', 'Vitamina K', 'Calcio'],
      },
      'tomato': {
        'calories': 18.0,
        'protein': 0.9,
        'carbs': 3.9,
        'fat': 0.2,
        'fiber': 1.2,
        'benefits': ['Rico en licopeno', 'Antioxidantes'],
        'micronutrients': ['Vitamina C', 'Potasio'],
      },
      'lettuce': {
        'calories': 15.0,
        'protein': 1.4,
        'carbs': 2.9,
        'fat': 0.2,
        'fiber': 1.3,
        'benefits': ['Muy bajo en calorías', 'Hidratante'],
        'micronutrients': ['Vitamina A', 'Vitamina K'],
      },
      'potato': {
        'calories': 77.0,
        'protein': 2.0,
        'carbs': 17.0,
        'fat': 0.1,
        'fiber': 2.2,
        'benefits': ['Fuente de carbohidratos', 'Rico en potasio'],
        'micronutrients': ['Potasio', 'Vitamina C'],
      },

      // COMIDAS PREPARADAS
      'hamburger': {
        'calories': 295.0,
        'protein': 17.0,
        'carbs': 24.0,
        'fat': 14.0,
        'fiber': 1.5,
        'benefits': ['Completo en macronutrientes'],
        'micronutrients': ['Hierro', 'Vitamina B12'],
      },
      'burger': {
        'calories': 295.0,
        'protein': 17.0,
        'carbs': 24.0,
        'fat': 14.0,
        'fiber': 1.5,
        'benefits': ['Completo en macronutrientes'],
        'micronutrients': ['Hierro', 'Vitamina B12'],
      },
      'pizza': {
        'calories': 266.0,
        'protein': 11.0,
        'carbs': 33.0,
        'fat': 10.0,
        'fiber': 2.3,
        'benefits': ['Completo en macronutrientes'],
        'micronutrients': ['Calcio', 'Hierro'],
      },
      'sandwich': {
        'calories': 250.0,
        'protein': 12.0,
        'carbs': 30.0,
        'fat': 9.0,
        'fiber': 2.5,
        'benefits': ['Comida completa y práctica'],
        'micronutrients': ['Hierro', 'Vitamina B'],
      },
      'salad': {
        'calories': 52.0,
        'protein': 2.5,
        'carbs': 8.0,
        'fat': 1.5,
        'fiber': 3.0,
        'benefits': ['Bajo en calorías', 'Alto en fibra'],
        'micronutrients': ['Vitamina A', 'Vitamina C', 'Hierro'],
      },

      // POSTRES Y SNACKS
      'cookie': {
        'calories': 488.0,
        'protein': 6.0,
        'carbs': 65.0,
        'fat': 23.0,
        'fiber': 2.0,
        'benefits': ['Energía rápida'],
        'micronutrients': ['Hierro', 'Calcio'],
      },
      'cake': {
        'calories': 257.0,
        'protein': 4.0,
        'carbs': 38.0,
        'fat': 10.0,
        'fiber': 0.9,
        'benefits': ['Energía rápida'],
        'micronutrients': ['Calcio'],
      },
      'chocolate': {
        'calories': 546.0,
        'protein': 5.0,
        'carbs': 61.0,
        'fat': 31.0,
        'fiber': 7.0,
        'benefits': ['Antioxidantes', 'Mejora el ánimo'],
        'micronutrients': ['Magnesio', 'Hierro'],
      },
      'ice cream': {
        'calories': 207.0,
        'protein': 3.5,
        'carbs': 24.0,
        'fat': 11.0,
        'fiber': 0.7,
        'benefits': ['Fuente de calcio'],
        'micronutrients': ['Calcio', 'Vitamina A'],
      },
    };
  }
}
