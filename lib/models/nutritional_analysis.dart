/// Modelo de datos para el análisis nutricional de alimentos
class NutritionalAnalysis {
  final String nombre;
  final String porcionEstimada;
  final int calorias;
  final Macronutrientes macronutrientes;
  final List<String> micronutrientesDestacados;
  final List<String> beneficios;
  final String recomendaciones;
  final NivelSaludable nivelSaludable;
  final List<String> aptoPara;
  final DateTime fechaAnalisis;
  final String? imagePath;

  NutritionalAnalysis({
    required this.nombre,
    required this.porcionEstimada,
    required this.calorias,
    required this.macronutrientes,
    required this.micronutrientesDestacados,
    required this.beneficios,
    required this.recomendaciones,
    required this.nivelSaludable,
    required this.aptoPara,
    required this.fechaAnalisis,
    this.imagePath,
  });

  factory NutritionalAnalysis.fromJson(Map<String, dynamic> json) {
    return NutritionalAnalysis(
      nombre: json['nombre'] ?? 'Alimento desconocido',
      porcionEstimada: json['porcion_estimada'] ?? 'N/A',
      calorias: json['calorias'] ?? 0,
      macronutrientes: Macronutrientes.fromJson(json['macronutrientes'] ?? {}),
      micronutrientesDestacados:
          List<String>.from(json['micronutrientes_destacados'] ?? []),
      beneficios: List<String>.from(json['beneficios'] ?? []),
      recomendaciones: json['recomendaciones'] ?? '',
      nivelSaludable: _parseNivelSaludable(json['nivel_saludable']),
      aptoPara: List<String>.from(json['apto_para'] ?? []),
      fechaAnalisis: DateTime.now(),
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'porcion_estimada': porcionEstimada,
      'calorias': calorias,
      'macronutrientes': macronutrientes.toJson(),
      'micronutrientes_destacados': micronutrientesDestacados,
      'beneficios': beneficios,
      'recomendaciones': recomendaciones,
      'nivel_saludable': nivelSaludable.toString().split('.').last,
      'apto_para': aptoPara,
      'fecha_analisis': fechaAnalisis.toIso8601String(),
      'image_path': imagePath,
    };
  }

  static NivelSaludable _parseNivelSaludable(String? nivel) {
    switch (nivel?.toLowerCase()) {
      case 'alto':
        return NivelSaludable.alto;
      case 'medio':
        return NivelSaludable.medio;
      case 'bajo':
        return NivelSaludable.bajo;
      default:
        return NivelSaludable.medio;
    }
  }
}

/// Macronutrientes del alimento
class Macronutrientes {
  final double proteinas;
  final double carbohidratos;
  final double grasas;
  final double fibra;

  Macronutrientes({
    required this.proteinas,
    required this.carbohidratos,
    required this.grasas,
    required this.fibra,
  });

  factory Macronutrientes.fromJson(Map<String, dynamic> json) {
    return Macronutrientes(
      proteinas: (json['proteinas'] ?? 0).toDouble(),
      carbohidratos: (json['carbohidratos'] ?? 0).toDouble(),
      grasas: (json['grasas'] ?? 0).toDouble(),
      fibra: (json['fibra'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proteinas': proteinas,
      'carbohidratos': carbohidratos,
      'grasas': grasas,
      'fibra': fibra,
    };
  }

  double get totalMacros => proteinas + carbohidratos + grasas;
}

/// Nivel de saludabilidad del alimento
enum NivelSaludable {
  bajo,
  medio,
  alto,
}
