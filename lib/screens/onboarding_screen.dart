import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/navigation/app_routes.dart';

/// Pantalla de Onboarding
/// Muestra un carousel introductorio con imágenes motivacionales
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Bienvenido a Vivofit',
      description: 'Tu compañero fitness personalizado para alcanzar tus metas',
      icon: Icons.fitness_center,
    ),
    OnboardingItem(
      title: 'Entrena con Propósito',
      description: 'Accede a rutinas diseñadas por profesionales',
      icon: Icons.sports_gymnastics,
    ),
    OnboardingItem(
      title: 'Nutrición Balanceada',
      description: 'Descubre recetas saludables y nutritivas',
      icon: Icons.restaurant_menu,
    ),
    OnboardingItem(
      title: 'Alcanza tus Objetivos',
      description: 'Transforma tu cuerpo y tu vida',
      icon: Icons.emoji_events,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Botón de saltar
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: CustomTextButton(
                  text: 'Saltar',
                  onPressed: () => context.go(AppRoutes.login),
                ),
              ),
            ),

            // PageView con contenido
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _buildPage(_items[index]);
                },
              ),
            ),

            // Indicadores de página
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (index) => _buildPageIndicator(index),
              ),
            ),

            const SizedBox(height: AppTheme.paddingLarge),

            // Botones de navegación
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: _currentPage == _items.length - 1
                  ? Column(
                      children: [
                        CustomButton(
                          text: 'Comenzar',
                          onPressed: () => context.go(AppRoutes.register),
                          icon: Icons.arrow_forward,
                        ),
                        const SizedBox(height: AppTheme.paddingMedium),
                        CustomTextButton(
                          text: '¿Ya tienes cuenta? Inicia sesión',
                          onPressed: () => context.go(AppRoutes.login),
                        ),
                      ],
                    )
                  : CustomButton(
                      text: 'Siguiente',
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icons.arrow_forward,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícono/Imagen
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: ColorPalette.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 100,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: AppTheme.paddingXLarge),

          // Título
          Text(
            item.title,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTheme.paddingMedium),

          // Descripción
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorPalette.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? ColorPalette.primary
            : ColorPalette.textTertiary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Modelo para items del onboarding
class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
