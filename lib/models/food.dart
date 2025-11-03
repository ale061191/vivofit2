/// Modelo de Alimento
/// Representa un alimento o receta en la sección de nutrición
class Food {
  final String id;
  final String name;
  final String description;
  final String category; // 'breakfast', 'lunch', 'dinner', 'snack'
  final int preparationTimeMinutes;
  final int calories;
  final double protein; // en gramos
  final double carbs; // en gramos
  final double fats; // en gramos
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> preparationSteps;
  final int servings;
  final String difficulty; // 'easy', 'medium', 'hard'
  final List<String> tags; // 'vegan', 'gluten-free', 'high-protein', etc.

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.preparationTimeMinutes,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.imageUrl,
    required this.ingredients,
    required this.preparationSteps,
    this.servings = 1,
    this.difficulty = 'medium',
    this.tags = const [],
  });

  /// Retorna la categoría traducida
  String get categoryTranslated {
    const translations = {
      'breakfast': 'Desayuno',
      'lunch': 'Almuerzo',
      'dinner': 'Cena',
      'snack': 'Merienda',
    };
    return translations[category] ?? category;
  }

  /// Retorna la dificultad traducida
  String get difficultyTranslated {
    const translations = {
      'easy': 'Fácil',
      'medium': 'Media',
      'hard': 'Difícil',
    };
    return translations[difficulty] ?? difficulty;
  }

  /// Calcula las calorías totales
  double get totalCalories => calories.toDouble();

  /// Retorna información nutricional formateada
  String get nutritionSummary {
    return 'P: ${protein.toStringAsFixed(1)}g | C: ${carbs.toStringAsFixed(1)}g | G: ${fats.toStringAsFixed(1)}g';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'preparationTimeMinutes': preparationTimeMinutes,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'preparationSteps': preparationSteps,
      'servings': servings,
      'difficulty': difficulty,
      'tags': tags,
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      preparationTimeMinutes: json['preparationTimeMinutes'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fats: json['fats'].toDouble(),
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
      preparationSteps: List<String>.from(json['preparationSteps']),
      servings: json['servings'] ?? 1,
      difficulty: json['difficulty'] ?? 'medium',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  /// Alimentos mockeados para testing
  static List<Food> mockList() {
    return [
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
        description: 'Almuerzo balanceado con proteína magra y carbohidratos complejos',
        category: 'lunch',
        preparationTimeMinutes: 35,
        calories: 520,
        protein: 45,
        carbs: 55,
        fats: 10,
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
  }

  /// Filtra alimentos por categoría
  static List<Food> filterByCategory(List<Food> foods, String category) {
    if (category == 'all') return foods;
    return foods.where((food) => food.category == category).toList();
  }

  /// Busca alimentos por nombre o descripción
  static List<Food> search(List<Food> foods, String query) {
    if (query.isEmpty) return foods;
    final lowerQuery = query.toLowerCase();
    return foods.where((food) =>
      food.name.toLowerCase().contains(lowerQuery) ||
      food.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
