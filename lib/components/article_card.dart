import 'package:flutter/material.dart';
import 'package:vivofit/models/article.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';

/// Card visual para mostrar un artículo
class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;
  const ArticleCard({Key? key, required this.article, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: ColorPalette.cardBackground,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                bottomLeft: Radius.circular(AppTheme.radiusMedium),
              ),
              child: article.imageUrl != null
                  ? Image.asset(
                      article.imageUrl!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 80,
                        width: 80,
                        color: ColorPalette.background,
                        child: const Center(
                          child: Icon(Icons.article,
                              size: 32, color: ColorPalette.primary),
                        ),
                      ),
                    )
                  : Container(
                      height: 80,
                      width: 80,
                      color: ColorPalette.background,
                      child: const Center(
                        child: Icon(Icons.article,
                            size: 32, color: ColorPalette.primary),
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.author,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${article.readTimeMinutes} min lectura',
                        style: const TextStyle(color: ColorPalette.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
