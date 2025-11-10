/// Utilidad centralizada para datos mock de modelos
library generic_mock_data;

import 'routine.dart';
import 'article.dart';
import 'program.dart';
import 'food.dart';
import 'membership.dart';
import 'user.dart';
import 'workout_session.dart';

class GenericMockData {
  static List<Routine> routines = [
    Routine(
      id: 'routine_1',
      name: 'Chest Power Workout',
      description: 'Rutina intensiva para desarrollar el pecho',
      muscleGroup: 'chest',
      durationMinutes: 45,
      estimatedCalories: 380,
      difficulty: 'medium',
      videoUrl: 'https://example.com/chest_workout.mp4',
      thumbnailUrl: 'assets/images/onboarding/image7.png',
      exercises: Exercise.mockListChest(),
      programId: 'program_1',
      isPremium: true,
    ),
    Routine(
      id: 'routine_2',
      name: 'Back Strength',
      description: 'Fortalece tu espalda con estos ejercicios',
      muscleGroup: 'back',
      durationMinutes: 40,
      estimatedCalories: 350,
      difficulty: 'medium',
      videoUrl: 'https://example.com/back_workout.mp4',
      thumbnailUrl: 'assets/images/onboarding/image9.png',
      exercises: Exercise.mockListBack(),
      isPremium: false,
    ),
    Routine(
      id: 'routine_3',
      name: 'Leg Day Intense',
      description: 'Día de piernas para máxima hipertrofia',
      muscleGroup: 'legs',
      durationMinutes: 60,
      estimatedCalories: 480,
      difficulty: 'hard',
      videoUrl: 'https://example.com/legs_workout.mp4',
      thumbnailUrl: 'assets/images/onboarding/image3.png',
      exercises: Exercise.mockListLegs(),
      programId: 'program_1',
      isPremium: true,
    ),
    Routine(
      id: 'routine_4',
      name: 'Arms Blast',
      description: 'Ejercicios para brazos tonificados',
      muscleGroup: 'arms',
      durationMinutes: 35,
      estimatedCalories: 280,
      difficulty: 'easy',
      thumbnailUrl: 'assets/images/onboarding/image1.png',
      exercises: Exercise.mockListArms(),
      isPremium: false,
    ),
  ];

  static List<Article> articles = [
    Article(
      id: 'article_1',
      title: 'Los 5 mejores ejercicios para ganar masa muscular',
      content: '''
# Los 5 mejores ejercicios para ganar masa muscular

La hipertrofia muscular es el objetivo de muchos atletas y entusiastas del fitness. En este artículo, exploraremos los ejercicios más efectivos para maximizar el crecimiento muscular.

## 1. Sentadillas
Las sentadillas son el rey de los ejercicios para piernas. Trabajan múltiples grupos musculares simultáneamente.

## 2. Press de Banca
Ejercicio fundamental para el desarrollo del pecho, hombros y tríceps.

## 3. Peso Muerto
Uno de los mejores ejercicios compuestos que existe, trabaja casi todo el cuerpo.

## 4. Dominadas
Excelente para desarrollar la espalda y los bíceps.

## 5. Press Militar
Ideal para hombros fuertes y definidos.

**Recuerda:** La consistencia y la progresión son clave para ver resultados.
        ''',
      author: 'Dr. Carlos Fitness',
      authorImageUrl: 'https://via.placeholder.com/50',
      imageUrl: 'assets/images/blog/masaMuscular.webp',
      topic: 'training',
      readTimeMinutes: 5,
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      tags: ['hipertrofia', 'ejercicios', 'masa muscular'],
      views: 1248,
      likes: 342,
    ),
    Article(
      id: 'article_2',
      title: 'Guía completa de nutrición para principiantes',
      content: '''
# Guía completa de nutrición para principiantes

La nutrición es fundamental para alcanzar tus objetivos fitness. Aquí te presentamos una guía completa para comenzar.

## Macronutrientes

### Proteínas
Esenciales para la reparación y crecimiento muscular. Consume 1.6-2.2g por kg de peso corporal.

### Carbohidratos
Tu fuente principal de energía. Prioriza carbohidratos complejos.

### Grasas
Necesarias para la producción hormonal. Incluye grasas saludables en cada comida.

## Timing
- Pre-entrenamiento: Carbohidratos + proteína moderada
- Post-entrenamiento: Proteína + carbohidratos de rápida absorción

## Hidratación
Bebe al menos 2-3 litros de agua al día.
        ''',
      author: 'Nutricionista Ana López',
      authorImageUrl: 'https://via.placeholder.com/50',
      imageUrl: 'assets/images/blog/nutricionFitness.jpg',
      topic: 'nutrition',
      readTimeMinutes: 8,
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      tags: ['nutrición', 'principiantes', 'macros'],
      views: 2156,
      likes: 589,
    ),
    Article(
      id: 'article_3',
      title: 'Cómo mantener la motivación en tu viaje fitness',
      content: '''
# Cómo mantener la motivación en tu viaje fitness

La motivación es uno de los mayores desafíos en el fitness. Aquí te damos estrategias comprobadas.

## Establece metas SMART
- Específicas
- Medibles
- Alcanzables
- Relevantes
- Con tiempo definido

## Crea una rutina
La disciplina vence a la motivación. Haz del ejercicio un hábito.

## Celebra pequeños logros
Cada progreso cuenta, no importa cuán pequeño sea.

## Encuentra tu por qué
Conecta con la razón profunda por la que quieres cambiar.

## Únete a una comunidad
El apoyo social es fundamental para mantener la consistencia.
        ''',
      author: 'Coach Miguel Pérez',
      authorImageUrl: 'https://via.placeholder.com/50',
      imageUrl: 'assets/images/blog/motivacionFitness.jpg',
      topic: 'wellness',
      readTimeMinutes: 6,
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      tags: ['motivación', 'mindset', 'hábitos'],
      views: 1876,
      likes: 421,
    ),
  ];

  static List<Program> programs = [
    Program(
      id: 'program_1',
      name: 'Full Body Transformation',
      description: 'Programa completo para transformar tu cuerpo en 12 semanas',
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

  static List<Food> foods = [
    Food(
      id: 'food_1',
      name: 'Avena con Proteína',
      description: 'Desayuno completo alto en proteína y fibra',
      category: 'breakfast',
      preparationTimeMinutes: 10,
      calories: 420,
      protein: 32,
      carbs: 48,
      fats: 12,
      imageUrl: 'assets/images/nutrition/avenaConProteina.jpg',
      ingredients: [
        '80g de avena',
        '1 scoop de proteína',
        '200ml de leche de almendras',
        '1 plátano',
        '1 cucharada de mantequilla de maní',
      ],
      preparationSteps: [
        'Cocina la avena con la leche de almendras',
        'Añade la proteína y mezcla bien',
        'Agrega el plátano en rodajas',
        'Decora con mantequilla de maní',
      ],
      difficulty: 'easy',
      tags: ['high-protein', 'pre-workout'],
    ),
    Food(
      id: 'food_2',
      name: 'Pollo con Batata',
      description:
          'Almuerzo balanceado con proteína magra y carbohidratos complejos',
      category: 'lunch',
      preparationTimeMinutes: 35,
      calories: 520,
      protein: 45,
      carbs: 55,
      fats: 10,
      imageUrl: 'assets/images/nutrition/polloConBatata.jpg',
      ingredients: [
        '200g de pechuga de pollo',
        '200g de batata',
        'Especias al gusto',
        'Aceite de oliva',
        'Vegetales verdes',
      ],
      preparationSteps: [
        'Sazona el pollo con especias',
        'Cocina el pollo a la plancha',
        'Hornea la batata hasta que esté suave',
        'Sirve con vegetales al vapor',
      ],
      difficulty: 'medium',
      tags: ['high-protein', 'post-workout'],
    ),
    Food(
      id: 'food_3',
      name: 'Ensalada de Atún',
      description: 'Cena ligera y nutritiva rica en omega-3',
      category: 'dinner',
      preparationTimeMinutes: 15,
      calories: 340,
      protein: 38,
      carbs: 22,
      fats: 12,
      imageUrl: 'assets/images/nutrition/ensaladaDeAtun.jpg',
      ingredients: [
        '1 lata de atún',
        'Lechuga mixta',
        'Tomate cherry',
        'Pepino',
        'Aceite de oliva y limón',
      ],
      preparationSteps: [
        'Lava y corta los vegetales',
        'Mezcla todos los ingredientes',
        'Aliña con aceite de oliva y limón',
        'Agrega el atún desmenuzado',
      ],
      difficulty: 'easy',
      tags: ['low-carb', 'high-protein'],
    ),
    Food(
      id: 'food_4',
      name: 'Batido Proteico',
      description: 'Merienda rápida post-entrenamiento',
      category: 'snack',
      preparationTimeMinutes: 5,
      calories: 280,
      protein: 30,
      carbs: 28,
      fats: 6,
      imageUrl: 'assets/images/nutrition/batidoProteico.jpg',
      ingredients: [
        '1 scoop de proteína',
        '1 plátano',
        '200ml de leche',
        'Hielo',
      ],
      preparationSteps: [
        'Añade todos los ingredientes a la licuadora',
        'Licúa hasta obtener una mezcla homogénea',
        'Sirve inmediatamente',
      ],
      difficulty: 'easy',
      tags: ['post-workout', 'quick'],
    ),
  ];

  static List<Membership> memberships = [
    Membership(
      id: 'membership_1',
      userId: '1',
      programId: 'program_1',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 69)), // 12 semanas
      paidAmount: 49.99,
      status: 'active',
      paymentReferenceId: 'payment_123',
    ),
  ];

  static List<User> users = [User.mock()];
  static List<WorkoutSession> workoutSessions = [];
}
