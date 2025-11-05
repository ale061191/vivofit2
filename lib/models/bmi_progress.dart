/// Modelo para el progreso del IMC (Índice de Masa Corporal)
class BMIProgress {
  final double initialBMI;
  final double currentBMI;
  final double targetBMI;
  final double initialWeight;
  final double currentWeight;
  final double targetWeight;
  final int totalCaloriesBurned;
  final DateTime startDate;
  final DateTime? lastUpdateDate;

  BMIProgress({
    required this.initialBMI,
    required this.currentBMI,
    required this.targetBMI,
    required this.initialWeight,
    required this.currentWeight,
    required this.targetWeight,
    required this.totalCaloriesBurned,
    required this.startDate,
    this.lastUpdateDate,
  });

  /// Calcula el porcentaje de progreso hacia el objetivo
  double get progressPercentage {
    if (initialBMI == targetBMI) return 100;

    final totalChange = initialBMI - targetBMI;
    final currentChange = initialBMI - currentBMI;

    if (totalChange == 0) return 0;

    return (currentChange / totalChange * 100).clamp(0, 100);
  }

  /// Calcula cuánto IMC ha bajado desde el inicio
  double get bmiReduced {
    return initialBMI - currentBMI;
  }

  /// Calcula cuánto peso ha perdido en kg
  double get weightLost {
    return initialWeight - currentWeight;
  }

  /// Calcula cuánto falta para alcanzar el objetivo de IMC
  double get bmiRemaining {
    final remaining = currentBMI - targetBMI;
    return remaining > 0 ? remaining : 0;
  }

  /// Calcula cuánto peso falta perder para alcanzar el objetivo
  double get weightRemaining {
    final remaining = currentWeight - targetWeight;
    return remaining > 0 ? remaining : 0;
  }

  /// Estima cuántas calorías se necesitan quemar por kg de peso
  /// Aproximadamente 7700 calorías = 1 kg de grasa
  double get estimatedCaloriesPerKg => 7700;

  /// Calcula cuántas calorías faltan por quemar para alcanzar el objetivo
  double get caloriesRemainingToGoal {
    return weightRemaining * estimatedCaloriesPerKg;
  }

  /// Calcula el equivalente en kg de las calorías quemadas
  double get weightEquivalentBurned {
    return totalCaloriesBurned / estimatedCaloriesPerKg;
  }

  /// Verifica si el usuario está en su peso saludable
  bool get isHealthyWeight {
    return currentBMI >= 18.5 && currentBMI < 25;
  }

  /// Obtiene la categoría del IMC actual
  String get currentBMICategory {
    if (currentBMI < 18.5) return 'Bajo peso';
    if (currentBMI < 25) return 'Peso normal';
    if (currentBMI < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  /// Copia el modelo con valores opcionales modificados
  BMIProgress copyWith({
    double? initialBMI,
    double? currentBMI,
    double? targetBMI,
    double? initialWeight,
    double? currentWeight,
    double? targetWeight,
    int? totalCaloriesBurned,
    DateTime? startDate,
    DateTime? lastUpdateDate,
  }) {
    return BMIProgress(
      initialBMI: initialBMI ?? this.initialBMI,
      currentBMI: currentBMI ?? this.currentBMI,
      targetBMI: targetBMI ?? this.targetBMI,
      initialWeight: initialWeight ?? this.initialWeight,
      currentWeight: currentWeight ?? this.currentWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      totalCaloriesBurned: totalCaloriesBurned ?? this.totalCaloriesBurned,
      startDate: startDate ?? this.startDate,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
    );
  }

  /// Convierte a JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'initialBMI': initialBMI,
      'currentBMI': currentBMI,
      'targetBMI': targetBMI,
      'initialWeight': initialWeight,
      'currentWeight': currentWeight,
      'targetWeight': targetWeight,
      'totalCaloriesBurned': totalCaloriesBurned,
      'startDate': startDate.toIso8601String(),
      'lastUpdateDate': lastUpdateDate?.toIso8601String(),
    };
  }

  /// Crea desde JSON
  factory BMIProgress.fromJson(Map<String, dynamic> json) {
    return BMIProgress(
      initialBMI: (json['initialBMI'] as num).toDouble(),
      currentBMI: (json['currentBMI'] as num).toDouble(),
      targetBMI: (json['targetBMI'] as num).toDouble(),
      initialWeight: (json['initialWeight'] as num).toDouble(),
      currentWeight: (json['currentWeight'] as num).toDouble(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      totalCaloriesBurned: json['totalCaloriesBurned'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      lastUpdateDate: json['lastUpdateDate'] != null
          ? DateTime.parse(json['lastUpdateDate'] as String)
          : null,
    );
  }

  /// Crea un progreso inicial basado en el usuario
  /// Asume un objetivo de IMC saludable (23.0 como objetivo medio)
  factory BMIProgress.initial({
    required double currentBMI,
    required double currentWeight,
    required double height,
  }) {
    // Objetivo de IMC saludable (centro del rango normal: 18.5-25)
    const targetBMI = 23.0;

    // Calcular peso objetivo basado en IMC objetivo
    final heightInMeters = height / 100;
    final targetWeight = targetBMI * heightInMeters * heightInMeters;

    return BMIProgress(
      initialBMI: currentBMI,
      currentBMI: currentBMI,
      targetBMI: targetBMI,
      initialWeight: currentWeight,
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      totalCaloriesBurned: 0,
      startDate: DateTime.now(),
    );
  }
}
