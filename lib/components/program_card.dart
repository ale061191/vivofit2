import 'package:flutter/material.dart';
import 'package:vivofit/models/program.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';

/// Card visual para mostrar un programa
class ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback? onTap;
  const ProgramCard({super.key, required this.program, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 170,
        child: Card(
          color: ColorPalette.cardBackground,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusMedium),
                  topRight: Radius.circular(AppTheme.radiusMedium),
                ),
                child: program.imageUrl != null
                    ? Image.asset(
                        program.imageUrl!,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          color: ColorPalette.background,
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 48, color: ColorPalette.primary),
                          ),
                        ),
                      )
                    : Container(
                        height: 80,
                        color: ColorPalette.background,
                        child: const Center(
                          child: Icon(Icons.image,
                              size: 48, color: ColorPalette.primary),
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        program.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        program.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorPalette.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: ColorPalette.primary, size: 15),
                          const SizedBox(width: 4),
                          Text(
                            program.rating.toString(),
                            style: const TextStyle(
                                color: ColorPalette.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          const SizedBox(width: 12),
                          Text('${program.durationWeeks} semanas',
                              style: const TextStyle(
                                  color: ColorPalette.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
