/// Utilidad para cálculos relacionados con el IMC
class IMCCalculator {
  /// Calcula el IMC a partir de peso y altura
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

  /// Retorna la categoría del IMC
  static String getCategory(double? imc) {
    if (imc == null) return 'Sin datos';
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25) return 'Peso normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidad';
  }
}
