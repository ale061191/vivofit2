import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vivofit/components/custom_cards.dart';
import 'package:vivofit/models/food.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/services/gemini_service.dart';
import 'nutritional_analysis_screen.dart';

/// Pantalla de Nutrición
/// Muestra alimentos y recetas saludables
class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final List<Food> _allFoods = Food.mockList();
  List<Food> _filteredFoods = [];
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _filteredFoods = _allFoods;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFoods() {
    setState(() {
      _filteredFoods = Food.search(
        Food.filterByCategory(_allFoods, _selectedCategory),
        _searchController.text,
      );
    });
  }

  /// Solicita permisos de cámara
  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Abre la cámara y analiza el alimento
  Future<void> _analyzeFood() async {
    try {
      // Solicitar permiso de cámara
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Se requiere permiso de cámara para esta función'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Tomar foto
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // Mostrar loading
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: ColorPalette.primary),
                    SizedBox(height: 16),
                    Text(
                      'Analizando alimento con IA...',
                      style: TextStyle(
                        color: ColorPalette.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Esto puede tomar unos segundos',
                      style: TextStyle(
                        color: ColorPalette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Analizar con Gemini
      final imageFile = File(image.path);
      final analysis = await _geminiService.analyzeFood(imageFile);

      // Cerrar loading
      if (mounted) {
        Navigator.pop(context);
      }

      // Mostrar resultados
      if (analysis != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NutritionalAnalysisScreen(
              analysis: analysis,
              imageFile: imageFile,
            ),
          ),
        );
      }
    } catch (e) {
      // Cerrar loading si está abierto
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // Mostrar error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al analizar: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      debugPrint('Error en análisis: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrición'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _analyzeFood,
        backgroundColor: ColorPalette.primary,
        child: const Icon(
          Icons.auto_awesome, // Icono de IA/Sparkles
          color: Colors.black,
          size: 28,
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterFoods(),
              decoration: InputDecoration(
                hintText: 'Buscar alimentos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterFoods();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Filtros de categoría
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip('all', 'Todos'),
                _buildCategoryChip('breakfast', 'Desayuno'),
                _buildCategoryChip('lunch', 'Almuerzo'),
                _buildCategoryChip('dinner', 'Cena'),
                _buildCategoryChip('snack', 'Merienda'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Lista de alimentos
          Expanded(
            child: _filteredFoods.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron alimentos',
                      style: TextStyle(color: ColorPalette.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];
                      return FoodCard(
                        name: food.name,
                        category: food.categoryTranslated,
                        preparationTime: food.preparationTimeMinutes,
                        calories: food.calories,
                        imageUrl: food.imageUrl,
                        onTap: () => AppRoutes.goToFoodDetail(context, food.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label) {
    final isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = value;
            _filterFoods();
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
