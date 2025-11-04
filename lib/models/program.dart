/// Modelo de Programa de Entrenamiento
/// Representa un programa completo que puede ser adquirido
class Program {
  final String id;
  final String name;
  final String description;
  final int durationWeeks;
  final double rating;
  final int totalReviews;
  final double price; // en USD o Bs
  final String? imageUrl;
  final String level; // 'beginner', 'intermediate', 'advanced'
  final List<String> benefits;
  final List<String> routineIds; // IDs de rutinas incluidas
  final String trainer;
  final DateTime createdAt;
  final bool isPopular;

  Program({
    required this.id,
    required this.name,
    required this.description,
    required this.durationWeeks,
    required this.rating,
    required this.totalReviews,
    required this.price,
    this.imageUrl,
    required this.level,
    required this.benefits,
    required this.routineIds,
    required this.trainer,
    DateTime? createdAt,
    this.isPopular = false,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Retorna el nivel del programa traducido
  String get levelTranslated {
    switch (level) {
      case 'beginner':
        return 'Principiante';
      case 'intermediate':
        return 'Intermedio';
      case 'advanced':
        return 'Avanzado';
      default:
        return level;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'durationWeeks': durationWeeks,
      'rating': rating,
      'totalReviews': totalReviews,
      'price': price,
      'imageUrl': imageUrl,
      'level': level,
      'benefits': benefits,
      'routineIds': routineIds,
      'trainer': trainer,
      'createdAt': createdAt.toIso8601String(),
      'isPopular': isPopular,
    };
  }

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      durationWeeks: json['durationWeeks'],
      rating: json['rating'].toDouble(),
      totalReviews: json['totalReviews'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      level: json['level'],
      benefits: List<String>.from(json['benefits']),
      routineIds: List<String>.from(json['routineIds']),
      trainer: json['trainer'],
      createdAt: DateTime.parse(json['createdAt']),
      isPopular: json['isPopular'] ?? false,
    );
  }

  /// Programas mockeados para testing
  static List<Program> mockList() {
    return [
      Program(
        id: 'program_1',
        name: 'Full Body Transformation',
        description:
            'Programa completo para transformar tu cuerpo en 12 semanas',
        durationWeeks: 12,
        rating: 4.8,
        totalReviews: 342,
        price: 49.99,
        imageUrl: 'assets/images/onboarding/image14.png',
        level: 'intermediate',
        benefits: [
          'Rutinas personalizadas',
          'Seguimiento semanal',
          'Guía nutricional',
          'Soporte 24/7'
        ],
        routineIds: ['routine_1', 'routine_2', 'routine_3'],
        trainer: 'Laura Fitness',
        isPopular: true,
      ),
      Program(
        id: 'program_2',
        name: 'Strength & Power',
        description: 'Aumenta tu fuerza y potencia muscular',
        durationWeeks: 8,
        rating: 4.6,
        totalReviews: 218,
        price: 39.99,
        imageUrl: 'assets/images/onboarding/image15.png',
        level: 'advanced',
        benefits: [
          'Enfoque en fuerza',
          'Ejercicios compuestos',
          'Progresión avanzada'
        ],
        routineIds: ['routine_4', 'routine_5'],
        trainer: 'Miguel Strong',
      ),
      Program(
        id: 'program_3',
        name: 'Weight Loss Challenge',
        description: 'Pierde peso de forma saludable y sostenible',
        durationWeeks: 16,
        rating: 4.9,
        totalReviews: 528,
        price: 59.99,
        imageUrl: 'assets/images/onboarding/image6.png',
        level: 'beginner',
        benefits: [
          'Plan alimenticio incluido',
          'Cardio y tonificación',
          'Recetas saludables',
          'Comunidad de apoyo'
        ],
        routineIds: ['routine_6', 'routine_7', 'routine_8'],
        trainer: 'Ana Wellness',
        isPopular: true,
      ),
    ];
  }
}
