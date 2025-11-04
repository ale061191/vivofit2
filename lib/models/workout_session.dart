/// Modelo para representar una sesión de entrenamiento completada
class WorkoutSession {
  final String id;
  final String userId;
  final String programId;
  final String routineId;
  final DateTime completedAt;
  final int durationMinutes;
  final int caloriesBurned;
  final List<String> exercisesCompleted;
  final String notes;

  WorkoutSession({
    required this.id,
    required this.userId,
    required this.programId,
    required this.routineId,
    required this.completedAt,
    this.durationMinutes = 0,
    this.caloriesBurned = 0,
    this.exercisesCompleted = const [],
    this.notes = '',
  });

  /// Convierte el modelo a JSON para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'programId': programId,
      'routineId': routineId,
      'completedAt': completedAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'exercisesCompleted': exercisesCompleted,
      'notes': notes,
    };
  }

  /// Crea un modelo desde JSON
  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      programId: json['programId'] as String,
      routineId: json['routineId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      exercisesCompleted: (json['exercisesCompleted'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      notes: json['notes'] as String? ?? '',
    );
  }

  /// Copia el modelo con valores opcionales modificados
  WorkoutSession copyWith({
    String? id,
    String? userId,
    String? programId,
    String? routineId,
    DateTime? completedAt,
    int? durationMinutes,
    int? caloriesBurned,
    List<String>? exercisesCompleted,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      programId: programId ?? this.programId,
      routineId: routineId ?? this.routineId,
      completedAt: completedAt ?? this.completedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      notes: notes ?? this.notes,
    );
  }
}
