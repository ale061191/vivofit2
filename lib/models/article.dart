/// Modelo de Artículo de Blog
/// Representa un artículo sobre fitness, nutrición o wellness
class Article {
  final String id;
  final String title;
  final String content;
  final String author;
  final String authorImageUrl;
  final String? imageUrl;
  final String topic; // 'fitness', 'nutrition', 'wellness', 'training'
  final int readTimeMinutes;
  final DateTime publishedAt;
  final List<String> tags;
  final int views;
  final int likes;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.authorImageUrl,
    this.imageUrl,
    required this.topic,
    required this.readTimeMinutes,
    required this.publishedAt,
    this.tags = const [],
    this.views = 0,
    this.likes = 0,
  });

  /// Retorna el tema traducido
  String get topicTranslated {
    const translations = {
      'fitness': 'Fitness',
      'nutrition': 'Nutrición',
      'wellness': 'Bienestar',
      'training': 'Entrenamiento',
    };
    return translations[topic] ?? topic;
  }

  /// Retorna fecha formateada
  String get formattedDate {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${publishedAt.day} ${months[publishedAt.month - 1]} ${publishedAt.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'authorImageUrl': authorImageUrl,
      'imageUrl': imageUrl,
      'topic': topic,
      'readTimeMinutes': readTimeMinutes,
      'publishedAt': publishedAt.toIso8601String(),
      'tags': tags,
      'views': views,
      'likes': likes,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      authorImageUrl: json['authorImageUrl'],
      imageUrl: json['imageUrl'],
      topic: json['topic'],
      readTimeMinutes: json['readTimeMinutes'],
      publishedAt: DateTime.parse(json['publishedAt']),
      tags: List<String>.from(json['tags'] ?? []),
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
    );
  }

  /// Artículos mockeados para testing
  static List<Article> mockList() {
    return [
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
        topic: 'wellness',
        readTimeMinutes: 6,
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        tags: ['motivación', 'mindset', 'hábitos'],
        views: 1876,
        likes: 421,
      ),
    ];
  }

  /// Filtra artículos por tema
  static List<Article> filterByTopic(List<Article> articles, String topic) {
    if (topic == 'all') return articles;
    return articles.where((article) => article.topic == topic).toList();
  }

  /// Busca artículos por título o contenido
  static List<Article> search(List<Article> articles, String query) {
    if (query.isEmpty) return articles;
    final lowerQuery = query.toLowerCase();
    return articles.where((article) =>
      article.title.toLowerCase().contains(lowerQuery) ||
      article.content.toLowerCase().contains(lowerQuery) ||
      article.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
    ).toList();
  }
}
