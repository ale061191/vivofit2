import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vivofit/navigation/app_routes.dart';
import 'package:vivofit/services/stripe_service.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializar Stripe (Asegúrate de poner tu PK en StripeService)
    StripeService().init();
  }

  Future<void> _handleSubscribe(BuildContext context, String plan) async {
    setState(() => _isLoading = true);

    // Definir precios según el plan
    String amount = '0';
    switch (plan) {
      case 'monthly':
        amount = '24.99';
        break;
      case 'quarterly':
        amount = '59.99';
        break;
      case 'annual':
        amount = '149.99';
        break;
    }

    // Iniciar flujo de pago con Stripe
    final success = await StripeService().makePayment(
      context,
      amount: amount,
      currency: 'usd',
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        context.go(AppRoutes.main);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(AppRoutes.main),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Text(
                    'Tu transformación empieza ahora',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ColorPalette.textPrimary,
                            height: 1.3,
                          ),
                      children: const [
                        TextSpan(text: 'Prueba 7 días '),
                        TextSpan(
                          text: 'GRATIS',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: ColorPalette.primary,
                          ),
                        ),
                        TextSpan(text: ' de Vivofit Premium'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cancela en cualquier momento',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorPalette.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Annual Plan (Featured)
                  _buildPlanCard(
                    context,
                    title: 'Plan Anual',
                    price: '\$149.99',
                    period: '/año',
                    details: 'Solo \$12.50 al mes',
                    savings: 'Ahorra un 50%',
                    buttonText: 'Empezar mi prueba gratis',
                    isFeatured: true,
                    onPressed: () => _handleSubscribe(context, 'annual'),
                  ),

                  const SizedBox(height: 24),

                  // Quarterly Plan
                  _buildPlanCard(
                    context,
                    title: 'Plan Trimestral',
                    price: '\$59.99',
                    period: '/3 meses',
                    details: 'Equivalente a \$19.99 al mes',
                    savings: 'Ahorra un 20%',
                    buttonText: 'Obtener plan',
                    isFeatured: false,
                    onPressed: () => _handleSubscribe(context, 'quarterly'),
                  ),

                  const SizedBox(height: 16),

                  // Monthly Plan
                  _buildPlanCard(
                    context,
                    title: 'Plan Mensual',
                    price: '\$24.99',
                    period: '/mes',
                    details: 'Flexibilidad total',
                    savings: null,
                    buttonText: 'Obtener plan',
                    isFeatured: false,
                    onPressed: () => _handleSubscribe(context, 'monthly'),
                  ),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.main),
                    child: const Text(
                      'No gracias, continuaré con la versión gratuita',
                      style: TextStyle(color: ColorPalette.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ColorPalette.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    required String details,
    String? savings,
    required String buttonText,
    required bool isFeatured,
    required VoidCallback onPressed,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isFeatured
                ? ColorPalette.cardBackground
                : const Color(0xFF1E1E1E).withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isFeatured
                  ? ColorPalette.primary
                  : Colors.grey.withOpacity(0.2),
              width: isFeatured ? 2 : 1,
            ),
            boxShadow: isFeatured
                ? [
                    BoxShadow(
                      color: ColorPalette.primary.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isFeatured) const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isFeatured
                          ? ColorPalette.textPrimary
                          : ColorPalette.textSecondary,
                    ),
                  ),
                  if (savings != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isFeatured
                            ? ColorPalette.primary
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        savings,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isFeatured
                              ? Colors.black
                              : ColorPalette.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isFeatured
                          ? ColorPalette.textPrimary
                          : ColorPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    period,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ColorPalette.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                details,
                style: TextStyle(
                  color: isFeatured
                      ? ColorPalette.textPrimary.withOpacity(0.8)
                      : ColorPalette.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFeatured ? ColorPalette.primary : Colors.transparent,
                    foregroundColor:
                        isFeatured ? Colors.black : ColorPalette.textSecondary,
                    side: BorderSide(
                      color: isFeatured
                          ? ColorPalette.primary
                          : ColorPalette.textSecondary.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isFeatured ? 4 : 0,
                  ),
                  child: Text(
                    buttonText.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1,
                      color: isFeatured ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isFeatured)
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9900), Color(0xFFFFB74D)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorPalette.primary.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'MÁS POPULAR',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
