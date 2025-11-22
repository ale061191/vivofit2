import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';

class PostRegistrationOnboardingScreen extends StatefulWidget {
  const PostRegistrationOnboardingScreen({super.key});

  @override
  State<PostRegistrationOnboardingScreen> createState() =>
      _PostRegistrationOnboardingScreenState();
}

class _PostRegistrationOnboardingScreenState
    extends State<PostRegistrationOnboardingScreen> {
  final PageController _pageController = PageController();

  // State for Step 1
  final List<String> _selectedReasons = [];
  final List<String> _reasons = [
    'Quiero perder peso y no sé cómo empezar',
    'Me siento sin energía y necesito un cambio',
    'Estoy pasando un mal momento y quiero usarlo como combustible',
    'Quiero más masa muscular y mejorar mi estética radicalmente',
  ];

  // State for Step 2
  final TextEditingController _goalController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStep1(),
            _buildStep2(),
            _buildStep3(),
            _buildStep4(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/logo/vivofit-logo.png',
          height: 80,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.fitness_center,
            size: 60,
            color: ColorPalette.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorPalette.primary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorPalette.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // Step 1: Reason for joining
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        children: [
          _buildHeader('Bienvenido a Vivofit', '¿Por qué estás aquí?'),
          Expanded(
            child: ListView.builder(
              itemCount: _reasons.length,
              itemBuilder: (context, index) {
                final reason = _reasons[index];
                final isSelected = _selectedReasons.contains(reason);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedReasons.remove(reason);
                        } else {
                          _selectedReasons.add(reason);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorPalette.primary.withOpacity(0.1)
                            : ColorPalette.cardBackground,
                        border: Border.all(
                          color: isSelected
                              ? ColorPalette.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              reason,
                              style: TextStyle(
                                color: isSelected
                                    ? ColorPalette.primary
                                    : ColorPalette.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: ColorPalette.primary),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CustomButton(
            text: 'Continuar',
            onPressed: _selectedReasons.isNotEmpty ? _nextPage : null,
          ),
        ],
      ),
    );
  }

  // Step 2: Goal visualization
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        children: [
          _buildHeader('¿Cuál es tu objetivo final?',
              'Visualízate en 3 meses. ¿Qué ves?'),
          Expanded(
            child: TextField(
              controller: _goalController,
              maxLines: 8,
              style: const TextStyle(color: ColorPalette.textPrimary),
              decoration: InputDecoration(
                hintText:
                    'Ej: Me veo con 5kg menos, con más energía para jugar con mis hijos y sintiéndome seguro en la playa...',
                hintStyle: TextStyle(
                    color: ColorPalette.textSecondary.withOpacity(0.5)),
                filled: true,
                fillColor: ColorPalette.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          CustomButton(
            text: 'Continuar',
            onPressed: () {
              if (_goalController.text.trim().isNotEmpty) {
                _nextPage();
              }
            },
          ),
        ],
      ),
    );
  }

  // Step 3: Commitment contract
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        children: [
          _buildHeader('Entendido', ''),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorPalette.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ColorPalette.primary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.handshake_outlined,
                    size: 48, color: ColorPalette.primary),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ColorPalette.textPrimary,
                          height: 1.5,
                        ),
                    children: const [
                      TextSpan(
                          text:
                              'Basado en tu necesidad y deseo, construiremos tu plan. Necesito que confíes en el proceso.\n\n'),
                      TextSpan(
                        text: '¿Te comprometes?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.primary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          CustomButton(
            text: 'Sí, me comprometo',
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  // Step 4: Summary & Confirmation
  Widget _buildStep4() {
    // Simple logic to generate summary based on selection
    String summaryText = "¡Excelente decisión! 🚀\n\n";

    if (_selectedReasons
        .any((r) => r.contains('perder peso') || r.contains('estética'))) {
      summaryText +=
          "Hemos analizado tu perfil y estimamos que con dedicación podrás ver cambios físicos notables en las primeras 4-6 semanas. 💪\n\n";
    }

    if (_selectedReasons.any((r) => r.contains('energía'))) {
      summaryText +=
          "Tu vitalidad aumentará significativamente desde la primera semana gracias al plan nutricional ajustado. ⚡\n\n";
    }

    if (_selectedReasons.any((r) => r.contains('mal momento'))) {
      summaryText +=
          "El ejercicio será tu mejor terapia. Canalizaremos esa energía para construir tu mejor versión. 🔥\n\n";
    }

    summaryText +=
        "Tu plan personalizado está listo para ser desplegado. El camino no será fácil, pero valdrá la pena.";

    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            'Análisis Completado',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorPalette.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              summaryText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          CustomButton(
            text: '¿Quieres continuar?',
            onPressed: () {
              // Navigate to Subscription Plans
              context.go(AppRoutes.subscriptionPlans);
            },
          ),
        ],
      ),
    );
  }
}
