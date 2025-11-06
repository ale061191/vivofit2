import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/nutritional_analysis.dart';
import '../../theme/color_palette.dart';
import '../../components/custom_button.dart';

/// Pantalla que muestra los resultados del análisis nutricional
class NutritionalAnalysisScreen extends StatelessWidget {
  final NutritionalAnalysis analysis;
  final File? imageFile;

  const NutritionalAnalysisScreen({
    super.key,
    required this.analysis,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis Nutricional'),
        backgroundColor: ColorPalette.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del alimento
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  imageFile!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 24),

            // Nombre del alimento
            Text(
              analysis.nombre,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColorPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Porción estimada
            Row(
              children: [
                const Icon(Icons.straighten,
                    color: ColorPalette.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Porción: ${analysis.porcionEstimada}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorPalette.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Card de calorías
            _buildCaloriesCard(),
            const SizedBox(height: 16),

            // Macronutrientes
            _buildMacrosCard(),
            const SizedBox(height: 16),

            // Nivel saludable
            _buildHealthLevelCard(),
            const SizedBox(height: 16),

            // Micronutrientes
            if (analysis.micronutrientesDestacados.isNotEmpty)
              _buildMicronutrientesCard(),
            const SizedBox(height: 16),

            // Beneficios
            if (analysis.beneficios.isNotEmpty) _buildBeneficiosCard(),
            const SizedBox(height: 16),

            // Recomendaciones
            _buildRecomendacionesCard(),
            const SizedBox(height: 16),

            // Apto para
            if (analysis.aptoPara.isNotEmpty) _buildAptoParaCard(),
            const SizedBox(height: 24),

            // Botón para cerrar
            CustomButton(
              text: 'Entendido',
              onPressed: () => Navigator.pop(context),
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: ColorPalette.cardGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: ColorPalette.primary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Text(
                '${analysis.calorias}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.primary,
                ),
              ),
              const Text(
                'kcal',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorPalette.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosCard() {
    final macros = analysis.macronutrientes;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: ColorPalette.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Macronutrientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMacroRow('Proteínas', macros.proteinas, Colors.blue),
          const SizedBox(height: 12),
          _buildMacroRow('Carbohidratos', macros.carbohidratos, Colors.orange),
          const SizedBox(height: 12),
          _buildMacroRow('Grasas', macros.grasas, Colors.red),
          const SizedBox(height: 12),
          _buildMacroRow('Fibra', macros.fibra, Colors.green),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String name, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: ColorPalette.textPrimary,
              ),
            ),
          ],
        ),
        Text(
          '${value.toStringAsFixed(1)}g',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorPalette.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthLevelCard() {
    Color levelColor;
    IconData levelIcon;
    String levelText;

    switch (analysis.nivelSaludable) {
      case NivelSaludable.alto:
        levelColor = Colors.green;
        levelIcon = Icons.check_circle;
        levelText = 'Muy Saludable';
        break;
      case NivelSaludable.medio:
        levelColor = Colors.orange;
        levelIcon = Icons.info;
        levelText = 'Moderadamente Saludable';
        break;
      case NivelSaludable.bajo:
        levelColor = Colors.red;
        levelIcon = Icons.warning;
        levelText = 'Consumir con Moderación';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: levelColor.withValues(alpha: 0.3 * 255), width: 2),
      ),
      child: Row(
        children: [
          Icon(levelIcon, color: levelColor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              levelText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: levelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicronutrientesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.spa, color: ColorPalette.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Micronutrientes Destacados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: analysis.micronutrientesDestacados
                .map((nutriente) => Chip(
                      label: Text(
                        nutriente,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor:
                          ColorPalette.primary.withValues(alpha: 0.2 * 255),
                      labelStyle: const TextStyle(color: ColorPalette.primary),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiosCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite, color: ColorPalette.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Beneficios para la Salud',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...analysis.beneficios.map((beneficio) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        beneficio,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecomendacionesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: ColorPalette.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Recomendaciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            analysis.recomendaciones,
            style: const TextStyle(
              fontSize: 14,
              color: ColorPalette.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAptoParaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPalette.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant_menu,
                  color: ColorPalette.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Apto Para',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: analysis.aptoPara
                .map((categoria) => Chip(
                      label: Text(
                        categoria,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor:
                          Colors.green.withValues(alpha: 0.2 * 255),
                      labelStyle: const TextStyle(color: Colors.green),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
