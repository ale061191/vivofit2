import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vivofit/components/bottom_nav_bar.dart';
import 'package:vivofit/screens/home/home_screen.dart';
import 'package:vivofit/screens/nutrition/nutrition_screen.dart';
import 'package:vivofit/screens/blog/blog_screen.dart';
import 'package:vivofit/screens/ranking/ranking_screen.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/navigation/app_routes.dart';

/// Pantalla principal con Bottom Navigation Bar
/// Contiene las 4 pantallas principales: Home, Nutrición, Ranking, Blog
/// El 5to tab "Más" abre un menú modal
class MainScreen extends StatefulWidget {
  final int? initialTab;

  const MainScreen({super.key, this.initialTab});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late final PageController _pageController;
  bool _isMenuOpen = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const NutritionScreen(),
    const RankingScreen(),
    const BlogScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab ?? 0;
    // Si el tab inicial es mayor que el número de pantallas (por ejemplo si venía de perfil),
    // lo reseteamos a 0
    if (_currentIndex >= _screens.length) {
      _currentIndex = 0;
    }
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == 4) {
      // Alternar visibilidad del menú "Más"
      setState(() {
        _isMenuOpen = !_isMenuOpen;
      });
    } else {
      setState(() {
        _currentIndex = index;
        _isMenuOpen = false; // Cerrar menú si se cambia de tab
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removido para que cada pantalla maneje su propio header si es necesario
      // o para tener una vista más limpia
      body: Stack(
        children: [
          // 1. Contenido Principal
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _screens,
          ),

          // 2. Capa de oscurecimiento (Overlay) cuando el menú está abierto
          if (_isMenuOpen)
            GestureDetector(
              onTap: () => setState(() => _isMenuOpen = false),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

          // 3. Menú "Más" desplegable (Estilo Duolingo)
          if (_isMenuOpen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorPalette.cardBackground,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      // Indicador de arrastre visual
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Opción Perfil
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Perfil',
                        onTap: () {
                          setState(() => _isMenuOpen = false);
                          context.push(AppRoutes.profile);
                        },
                      ),

                      // Opción Nuestros Profesionales
                      _buildMenuItem(
                        icon: Icons.medical_services_outlined,
                        title: 'Nuestros Profesionales',
                        onTap: () {
                          setState(() => _isMenuOpen = false);
                          context.push(AppRoutes.professionals);
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: ColorPalette.primary, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: ColorPalette.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing:
          const Icon(Icons.chevron_right, color: ColorPalette.textTertiary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
