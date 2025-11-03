/// Utilidad para calcular el Índice de Masa Corporal (IMC)
class IMCCalculator {
  /// Calcula el IMC a partir de peso y altura
  /// @param weight Peso en kilogramos
  /// @param height Altura en centímetros
  /// @return IMC calculado o null si los datos no son válidos
  static double? calculate({
    required double? weight,
    required double? height,
  }) {
    if (weight == null || height == null || height <= 0 || weight <= 0) {
      return null;
    }
    
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Retorna la categoría del IMC según los estándares de la OMS
  static String getCategory(double? imc) {
    if (imc == null) return 'Sin datos';
    
    if (imc < 16) return 'Delgadez severa';
    if (imc < 17) return 'Delgadez moderada';
    if (imc < 18.5) return 'Delgadez leve';
    if (imc < 25) return 'Peso normal';
    if (imc < 30) return 'Sobrepeso';
    if (imc < 35) return 'Obesidad leve';
    if (imc < 40) return 'Obesidad media';
    return 'Obesidad mórbida';
  }

  /// Retorna el rango saludable de peso para una altura dada
  /// @param height Altura en centímetros
  /// @return Map con peso mínimo y máximo saludable
  static Map<String, double> getHealthyWeightRange(double height) {
    final heightInMeters = height / 100;
    final minWeight = 18.5 * (heightInMeters * heightInMeters);
    final maxWeight = 24.9 * (heightInMeters * heightInMeters);
    
    return {
      'min': double.parse(minWeight.toStringAsFixed(1)),
      'max': double.parse(maxWeight.toStringAsFixed(1)),
    };
  }

  /// Retorna un color asociado a la categoría del IMC
  static String getCategoryColor(double? imc) {
    if (imc == null) return '#707070'; // Gris
    
    if (imc < 18.5) return '#2196F3'; // Azul (bajo peso)
    if (imc < 25) return '#4CAF50'; // Verde (normal)
    if (imc < 30) return '#FFC107'; // Amarillo (sobrepeso)
    return '#FF5252'; // Rojo (obesidad)
  }

  /// Retorna un mensaje descriptivo sobre el IMC
  static String getMessage(double? imc) {
    if (imc == null) {
      return 'Completa tu perfil con tu peso y altura para calcular tu IMC';
    }
    
    if (imc < 18.5) {
      return 'Tu IMC indica bajo peso. Considera consultar con un nutricionista.';
    }
    if (imc < 25) {
      return '¡Excelente! Tu IMC está en el rango saludable.';
    }
    if (imc < 30) {
      return 'Tu IMC indica sobrepeso. Un plan de ejercicio y nutrición puede ayudarte.';
    }
    return 'Tu IMC indica obesidad. Te recomendamos consultar con un profesional de la salud.';
  }

  /// Calcula las calorías diarias recomendadas (TMB + actividad)
  /// Usa la fórmula de Mifflin-St Jeor
  static double? calculateDailyCalories({
    required double? weight,
    required double? height,
    required int? age,
    required String? gender,
    required String activityLevel, // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  }) {
    if (weight == null || height == null || age == null || gender == null) {
      return null;
    }

    // Calcular TMB (Tasa Metabólica Basal)
    double tmb;
    if (gender.toLowerCase() == 'male') {
      tmb = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      tmb = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Aplicar factor de actividad
    double activityFactor;
    switch (activityLevel) {
      case 'sedentary':
        activityFactor = 1.2;
        break;
      case 'light':
        activityFactor = 1.375;
        break;
      case 'moderate':
        activityFactor = 1.55;
        break;
      case 'active':
        activityFactor = 1.725;
        break;
      case 'very_active':
        activityFactor = 1.9;
        break;
      default:
        activityFactor = 1.55;
    }

    return tmb * activityFactor;
  }

  /// Calcula el porcentaje de grasa corporal estimado
  /// Usa la fórmula de la Marina de EE.UU.
  static double? calculateBodyFatPercentage({
    required double? weight,
    required double? height,
    required String? gender,
    required double? waist, // en cm
    required double? neck, // en cm
    double? hip, // en cm (requerido para mujeres)
  }) {
    if (weight == null || height == null || gender == null || 
        waist == null || neck == null) {
      return null;
    }

    if (gender.toLowerCase() == 'female' && hip == null) {
      return null;
    }

    double bodyFat;
    if (gender.toLowerCase() == 'male') {
      bodyFat = 495 / (1.0324 - 0.19077 * _log10(waist - neck) + 
                       0.15456 * _log10(height)) - 450;
    } else {
      bodyFat = 495 / (1.29579 - 0.35004 * _log10(waist + hip! - neck) + 
                       0.22100 * _log10(height)) - 450;
    }

    return double.parse(bodyFat.toStringAsFixed(1));
  }

  // Función auxiliar para logaritmo base 10
  static double _log10(double x) {
    return (x > 0) ? (x.toString().length - 1).toDouble() : 0;
  }
}
