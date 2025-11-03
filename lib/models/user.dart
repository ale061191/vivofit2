/// Modelo de Usuario
/// Representa los datos de un usuario registrado en Vivofit
class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int? age;
  final double? height; // en centímetros
  final double? weight; // en kilogramos
  final String? phone;
  final String? location;
  final String? gender; // 'male', 'female', 'other'
  final List<String> activeMemberships; // IDs de programas activos
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.age,
    this.height,
    this.weight,
    this.phone,
    this.location,
    this.gender,
    List<String>? activeMemberships,
    DateTime? createdAt,
    this.updatedAt,
  })  : activeMemberships = activeMemberships ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// Calcula el IMC (Índice de Masa Corporal) del usuario
  /// Retorna null si no hay datos de altura o peso
  double? get imc {
    if (height == null || weight == null || height! <= 0) return null;
    final heightInMeters = height! / 100;
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Retorna la categoría del IMC
  String get imcCategory {
    final imcValue = imc;
    if (imcValue == null) return 'Sin datos';
    if (imcValue < 18.5) return 'Bajo peso';
    if (imcValue < 25) return 'Peso normal';
    if (imcValue < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  /// Verifica si el usuario tiene acceso a un programa específico
  bool hasMembership(String programId) {
    return activeMemberships.contains(programId);
  }

  /// Copia el usuario con campos actualizados
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    int? age,
    double? height,
    double? weight,
    String? phone,
    String? location,
    String? gender,
    List<String>? activeMemberships,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      activeMemberships: activeMemberships ?? this.activeMemberships,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte el usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'age': age,
      'height': height,
      'weight': weight,
      'phone': phone,
      'location': location,
      'gender': gender,
      'activeMemberships': activeMemberships,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Crea un usuario desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      age: json['age'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      phone: json['phone'],
      location: json['location'],
      gender: json['gender'],
      activeMemberships: List<String>.from(json['activeMemberships'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  /// Usuario mockeado para testing
  static User mock() {
    return User(
      id: '1',
      name: 'Carlos Rodríguez',
      email: 'carlos@example.com',
      photoUrl: null,
      age: 28,
      height: 175,
      weight: 75,
      phone: '+58 412-1234567',
      location: 'Caracas, Venezuela',
      gender: 'male',
      activeMemberships: ['program_1'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
}
