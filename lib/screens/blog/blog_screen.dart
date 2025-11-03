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
