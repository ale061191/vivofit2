import 'package:flutter/material.dart';
import 'package:vivofit/components/custom_cards.dart';
import 'package:vivofit/models/food.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrición'),
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
