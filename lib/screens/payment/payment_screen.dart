import 'package:flutter/material.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/utils/validators.dart';

/// Pantalla de Pago (Pago Móvil Venezolano)
class PaymentScreen extends StatefulWidget {
  final String programId;

  const PaymentScreen({super.key, required this.programId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();

  final List<String> _banks = [
    'Banco de Venezuela',
    'Banesco',
    'Mercantil',
    'Provincial',
    'Bancaribe',
    'Banco Exterior',
    'BOD',
  ];

  @override
  void dispose() {
    _bankController.dispose();
    _phoneController.dispose();
    _cedulaController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    // En producción: enviar datos de pago al servidor con ApiService
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pago Enviado'),
        content: const Text(
          'Tu pago ha sido registrado y será verificado en las próximas 24 horas.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago Móvil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Completa los datos de tu pago móvil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Banco',
                  prefixIcon: Icon(Icons.account_balance),
                ),
                items: _banks.map((bank) {
                  return DropdownMenuItem(value: bank, child: Text(bank));
                }).toList(),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Banco'),
                onChanged: (value) => _bankController.text = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.phoneVenezuela,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                  hintText: '0412-1234567',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cedulaController,
                validator: Validators.cedulaVenezuela,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  prefixIcon: Icon(Icons.badge),
                  hintText: 'V-12345678',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: Validators.amount,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: '0.00',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _referenceController,
                keyboardType: TextInputType.number,
                validator: Validators.referenceNumber,
                decoration: const InputDecoration(
                  labelText: 'Número de Referencia',
                  prefixIcon: Icon(Icons.confirmation_number),
                  hintText: '1234567890',
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Enviar Pago',
                onPressed: _handleSubmitPayment,
                icon: Icons.send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
