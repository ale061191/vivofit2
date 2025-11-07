import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/navigation/app_routes.dart';

/// Pantalla de Onboarding
/// Muestra un carousel introductorio con imágenes motivacionales y diseño moderno
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'BIENVENIDO A VIVOFIT',
      subtitle: 'TRANSFORMA TU CUERPO',
      description:
          'Tu compañero fitness personalizado para alcanzar tus metas. Entrena, nutre y transforma tu vida.',
      imageUrl: 'assets/images/onboarding/image1.png',
      showLogo: false, // Logo removido por solicitud del usuario
    ),
    OnboardingItem(
      title: 'ENTRENA CON PROPÓSITO',
      subtitle: 'RUTINAS PROFESIONALES',
      description:
          'Accede a rutinas diseñadas por expertos certificados. Cada ejercicio cuenta para tu progreso.',
      imageUrl: 'assets/images/onboarding/image9.png',
    ),
    OnboardingItem(
      title: 'NUTRICIÓN INTELIGENTE',
      subtitle: 'ALIMENTA TU CUERPO',
      description:
          'Descubre recetas balanceadas y deliciosas. La nutrición es el 70% de tu éxito.',
      imageUrl: 'assets/images/onboarding/image3.png',
    ),
    OnboardingItem(
      title: 'ALCANZA TUS METAS',
      subtitle: 'TU MEJOR VERSIÓN',
      description:
          'Monitorea tu progreso, supera tus límites y conviértete en la mejor versión de ti mismo.',
      imageUrl: 'assets/images/onboarding/image7.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Iniciar animación para la primera pantalla con delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Pequeño delay para asegurar que todo esté cargado
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _animationController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_currentPage + 1) / _items.length;

    return Scaffold(
      body: Stack(
        children: [
          // PageView con transiciones suaves y swipe bidireccional
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) async {
              setState(() {
                _currentPage = index;
              });
              // Reset animación inmediatamente (ocultar texto)
              _animationController.reset();

              // Esperar a que la transición de página termine completamente
              // La duración de animateToPage es 400ms, así que esperamos eso + delay adicional
              final delay = index > 0
                  ? const Duration(
                      milliseconds: 700) // 400ms transición + 300ms delay extra
                  : const Duration(
                      milliseconds: 100); // Delay mínimo para primera pantalla

              Future.delayed(delay, () {
                if (mounted) {
                  _animationController.forward();
                }
              });
            },
            itemCount: _items.length,
            // Permite deslizar en ambas direcciones
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildPage(_items[index]);
            },
          ),

          // Barra de progreso superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                children: [
                  // Barra de progreso animada
                  Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingLarge,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColorPalette.textTertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: MediaQuery.of(context).size.width * progress -
                          (AppTheme.paddingLarge * 2),
                      decoration: BoxDecoration(
                        gradient: ColorPalette.primaryGradient,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: ColorPalette.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Header con título y botón saltar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.paddingLarge,
                      vertical: AppTheme.paddingSmall,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Título VIVOFIT
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _items[_currentPage].title,
                            key: ValueKey(_currentPage),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        // Botón Saltar
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'Saltar',
                            style: TextStyle(
                              color: ColorPalette.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Indicadores y controles en la parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(AppTheme.paddingLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      ColorPalette.background,
                      ColorPalette.background.withValues(alpha: 0.9),
                      ColorPalette.background.withValues(alpha: 0.0),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicadores de página
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _items.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: _currentPage == index
                                ? ColorPalette.primaryGradient
                                : null,
                            color: _currentPage != index
                                ? ColorPalette.textTertiary
                                    .withValues(alpha: 0.3)
                                : null,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botones de navegación
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _currentPage == _items.length - 1
                          ? Column(
                              key: const ValueKey('last-page'),
                              children: [
                                CustomButton(
                                  text: 'Comenzar',
                                  onPressed: () =>
                                      context.go(AppRoutes.register),
                                  icon: Icons.arrow_forward,
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () => context.go(AppRoutes.login),
                                  child: const Text(
                                    '¿Ya tienes cuenta? Inicia sesión',
                                    style: TextStyle(
                                      color: ColorPalette.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : CustomButton(
                              key: const ValueKey('next-button'),
                              text: 'Siguiente',
                              onPressed: () {
                                _pageController.animateToPage(
                                  _currentPage + 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOutCubic,
                                );
                              },
                              icon: Icons.arrow_forward,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen de fondo a pantalla completa optimizada para móviles
        Image.asset(
          item.imageUrl,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si la imagen no se encuentra
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorPalette.cardBackground,
                    ColorPalette.background,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 100,
                  color: ColorPalette.primary,
                ),
              ),
            );
          },
        ),

        // Gradiente oscuro para mejor legibilidad del texto
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorPalette.background.withValues(alpha: 0.1),
                ColorPalette.background.withValues(alpha: 0.4),
                ColorPalette.background.withValues(alpha: 0.85),
                ColorPalette.background,
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        ),

        // Logo de VivoFit en la primera pantalla (centrado superior)
        if (item.showLogo)
          Positioned(
            top: screenHeight * 0.25,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _animationController,
              child: Center(
                child: Container(
                  width: isSmallScreen ? 180 : 220,
                  height: isSmallScreen ? 180 : 220,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorPalette.background.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: ColorPalette.primary.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo/vivofit-logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback si el logo no existe
                      return Container(
                        decoration: BoxDecoration(
                          gradient: ColorPalette.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'VIVO',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 32 : 38,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                'FIT',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 32 : 38,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

        // Contenido de texto con animación (optimizado para móviles)
        Positioned(
          bottom: isSmallScreen ? 160 : 200,
          left: 0,
          right: 0,
          child: FadeTransition(
            opacity: _animationController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              )),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 20 : AppTheme.paddingXLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtítulo en color primario (tamaño responsive)
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.primary,
                        height: 1.2,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    // Descripción (tamaño responsive)
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: ColorPalette.textPrimary.withValues(alpha: 0.95),
                        height: 1.5,
                        letterSpacing: 0.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.7),
                            offset: const Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Modelo para items del onboarding
class OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final bool showLogo; // Mostrar logo de VivoFit en esta pantalla

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    this.showLogo = false,
  });
}
