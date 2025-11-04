/// Modelo de Rutina de Ejercicio
/// Representa una rutina individual con ejercicios específicos
class Routine {
  final String id;
  final String name;
  final String description;
  final String
      muscleGroup; // 'chest', 'back', 'legs', 'arms', 'shoulders', 'core', 'full'
  final int durationMinutes;
  final int estimatedCalories;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String? videoUrl;
  final String? thumbnailUrl;
  final List<Exercise> exercises;
  final String? programId; // ID del programa al que pertenece (si aplica)
  final bool isPremium; // Indica si requiere membresía

  Routine({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.durationMinutes,
    required this.estimatedCalories,
    required this.difficulty,
    this.videoUrl,
    this.thumbnailUrl,
    required this.exercises,
    this.programId,
    this.isPremium = false,
  });

  /// Retorna el grupo muscular traducido
  String get muscleGroupTranslated {
    const translations = {
      'chest': 'Pecho',
      'back': 'Espalda',
      'legs': 'Piernas',
      'arms': 'Brazos',
      'shoulders': 'Hombros',
      'core': 'Core',
      'full': 'Cuerpo completo',
    };
    return translations[muscleGroup] ?? muscleGroup;
  }

  /// Retorna la dificultad traducida
  String get difficultyTranslated {
    const translations = {
      'easy': 'Fácil',
      'medium': 'Medio',
      'hard': 'Difícil',
    };
    return translations[difficulty] ?? difficulty;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'muscleGroup': muscleGroup,
      'durationMinutes': durationMinutes,
      'estimatedCalories': estimatedCalories,
      'difficulty': difficulty,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'programId': programId,
      'isPremium': isPremium,
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      muscleGroup: json['muscleGroup'],
      durationMinutes: json['durationMinutes'],
      estimatedCalories: json['estimatedCalories'],
      difficulty: json['difficulty'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      exercises:
          (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
      programId: json['programId'],
      isPremium: json['isPremium'] ?? false,
    );
  }

  /// Rutinas mockeadas para testing
  static List<Routine> mockList() {
    return [
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
  }
}

/// Modelo de Ejercicio individual
class Exercise {
  final String name;
  final int sets;
  final int reps;
  final int? restSeconds;
  final String? notes;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.restSeconds,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'restSeconds': restSeconds,
      'notes': notes,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      restSeconds: json['restSeconds'],
      notes: json['notes'],
    );
  }

  static List<Exercise> mockListChest() {
    return [
      Exercise(name: 'Press de banca', sets: 4, reps: 10, restSeconds: 90),
      Exercise(
          name: 'Aperturas con mancuernas', sets: 3, reps: 12, restSeconds: 60),
      Exercise(name: 'Fondos en paralelas', sets: 3, reps: 15, restSeconds: 60),
      Exercise(name: 'Pullover', sets: 3, reps: 12, restSeconds: 60),
    ];
  }

  static List<Exercise> mockListBack() {
    return [
      Exercise(name: 'Dominadas', sets: 4, reps: 8, restSeconds: 90),
      Exercise(name: 'Remo con barra', sets: 4, reps: 10, restSeconds: 90),
      Exercise(name: 'Peso muerto', sets: 3, reps: 8, restSeconds: 120),
    ];
  }

  static List<Exercise> mockListLegs() {
    return [
      Exercise(name: 'Sentadillas', sets: 5, reps: 10, restSeconds: 120),
      Exercise(name: 'Prensa de piernas', sets: 4, reps: 12, restSeconds: 90),
      Exercise(name: 'Curl femoral', sets: 3, reps: 15, restSeconds: 60),
      Exercise(
          name: 'Extensión de cuádriceps', sets: 3, reps: 15, restSeconds: 60),
    ];
  }

  static List<Exercise> mockListArms() {
    return [
      Exercise(name: 'Curl de bíceps', sets: 3, reps: 12, restSeconds: 60),
      Exercise(
          name: 'Extensión de tríceps', sets: 3, reps: 12, restSeconds: 60),
      Exercise(name: 'Martillo', sets: 3, reps: 10, restSeconds: 60),
    ];
  }
}
