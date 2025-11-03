import 'package:flutter/material.dart';
import 'package:vivofit/models/article.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';

/// Pantalla de Detalle de Artículo
/// Renderiza contenido de artículos con información del autor y engagement
class ArticleDetailScreen extends StatefulWidget {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool _isLiked = false;
  int _localLikes = 0;

  @override
  Widget build(BuildContext context) {
    // Buscar el artículo por ID
    final article = Article.mockList().firstWhere(
      (a) => a.id == widget.articleId,
      orElse: () => Article.mockList().first,
    );

    if (_localLikes == 0) {
      _localLikes = article.likes;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con imagen
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (article.imageUrl != null)
                    Image.network(
                      article.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: ColorPalette.cardBackgroundLight,
                      child: const Icon(
                        Icons.article,
                        size: 80,
                        color: ColorPalette.textTertiary,
                      ),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ColorPalette.background.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del autor
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: ColorPalette.cardBackgroundLight,
                        backgroundImage: NetworkImage(article.authorImageUrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.textPrimary,
                              ),
                            ),
                            Text(
                              article.formattedDate,
                              style: const TextStyle(
                                fontSize: 14,
                                color: ColorPalette.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Metadatos
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorPalette.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.topicTranslated,
                          style: const TextStyle(
                            color: ColorPalette.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildMetaInfo(
                        Icons.schedule,
                        '${article.readTimeMinutes} min',
                      ),
                      const SizedBox(width: 12),
                      _buildMetaInfo(
                        Icons.visibility,
                        '${article.views}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Contenido del artículo
                  Container(
                    decoration: BoxDecoration(
                      gradient: ColorPalette.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      article.content,
                      style: const TextStyle(
                        fontSize: 16,
                        color: ColorPalette.textSecondary,
                        height: 1.8,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Engagement (likes)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: ColorPalette.cardGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '¿Te gustó este artículo?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorPalette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_localLikes personas lo han valorado',
                              style: const TextStyle(
                                fontSize: 14,
                                color: ColorPalette.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isLiked = !_isLiked;
                              _localLikes += _isLiked ? 1 : -1;
                            });
                          },
                          icon: Icon(
                            _isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isLiked
                                ? ColorPalette.primary
                                : ColorPalette.textTertiary,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  if (article.tags.isNotEmpty) ...[
                    const Text(
                      'Etiquetas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tags.map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ColorPalette.cardBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ColorPalette.cardBackgroundLight,
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorPalette.textSecondary,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: ColorPalette.textTertiary, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: ColorPalette.textTertiary,
          ),
        ),
      ],
    );
  }
}
