import 'package:flutter/material.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';

/// Card genérico reutilizable para múltiples propósitos
class GenericCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final List<Widget>? additionalInfo;
  final Widget? content; // Nuevo parámetro para contenido personalizado
  final VoidCallback? onTap;
  final bool isLocked;
  final bool isPopular;
  final double? imageHeight;
  final double? imageWidth;
  final IconData? placeholderIcon;
  final Color? backgroundColor;
  final double? elevation;

  const GenericCard({
    super.key,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.additionalInfo,
    this.content,
    this.onTap,
    this.isLocked = false,
    this.isPopular = false,
    this.imageHeight,
    this.imageWidth,
    this.placeholderIcon,
    this.backgroundColor,
    this.elevation,
  });

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        height: imageHeight,
        width: imageWidth,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(
            placeholderIcon ?? Icons.image,
            size: 48,
            color: ColorPalette.textTertiary,
          ),
        ),
      );
    } else {
      return Image.asset(
        imageUrl,
        height: imageHeight,
        width: imageWidth,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(
            placeholderIcon ?? Icons.image,
            size: 48,
            color: ColorPalette.textTertiary,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor ?? ColorPalette.cardBackground,
        elevation: elevation ?? 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusMedium),
                  topRight: Radius.circular(AppTheme.radiusMedium),
                ),
                child: _buildImage(imageUrl!),
              ),
            if (isLocked)
              Container(
                color: Colors.black
                    .withOpacity(0.7), // Restauré el método original
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: ColorPalette.primary,
                    size: 32,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorPalette.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'POPULAR',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.textSecondary,
                        ),
                      ),
                    ),
                  if (content != null)
                    content!, // Renderizar contenido personalizado
                  if (additionalInfo != null) ...additionalInfo!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
