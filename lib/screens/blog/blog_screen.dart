import 'package:flutter/material.dart';
import 'package:vivofit/components/custom_cards.dart';
import 'package:vivofit/models/article.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/theme/color_palette.dart';

/// Pantalla de Blog
/// Muestra artículos sobre fitness, nutrición y bienestar
class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final List<Article> _allArticles = Article.mockList();
  List<Article> _filteredArticles = [];
  String _selectedTopic = 'all';

  @override
  void initState() {
    super.initState();
    _filteredArticles = _allArticles;
  }

  void _filterArticles() {
    setState(() {
      _filteredArticles = Article.filterByTopic(_allArticles, _selectedTopic);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: Column(
        children: [
          // Hero Section con imagen
          _buildHeroSection(),

          // Filtros de tema
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildTopicChip('all', 'Todos'),
                _buildTopicChip('fitness', 'Fitness'),
                _buildTopicChip('nutrition', 'Nutrición'),
                _buildTopicChip('wellness', 'Bienestar'),
                _buildTopicChip('training', 'Entrenamiento'),
              ],
            ),
          ),

          // Lista de artículos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                return ArticleCard(
                  title: article.title,
                  author: article.author,
                  topic: article.topicTranslated,
                  readTime: article.readTimeMinutes,
                  imageUrl: article.imageUrl,
                  onTap: () => AppRoutes.goToArticleDetail(context, article.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.asset(
                'assets/images/onboarding/image15.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorPalette.cardBackground,
                          ColorPalette.background,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.article,
                        size: 80,
                        color: ColorPalette.primary,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gradiente oscuro
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Contenido: Logo y texto
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo de VivoFit
                  Image.asset(
                    'assets/images/logo/vivofit-logo.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: ColorPalette.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'VF',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),

                  // Texto
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BLOG',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.primary,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 3,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: ColorPalette.primaryGradient,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Disfruta de los mejores artículos en Salud, entrenamiento y bienestar de interés',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: ColorPalette.textPrimary,
                                  height: 1.3,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String value, String label) {
    final isSelected = _selectedTopic == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedTopic = value;
            _filterArticles();
          });
        },
        backgroundColor: ColorPalette.cardBackground,
        selectedColor: ColorPalette.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : ColorPalette.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
