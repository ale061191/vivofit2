import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/models/program.dart';
import 'package:vivofit/services/user_service.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/utils/validators.dart';

/// Pantalla de Activación de Membresía
/// Permite al usuario comprar un programa mediante pago móvil venezolano
class ActivateMembershipScreen extends StatefulWidget {
  final String? programId;

  const ActivateMembershipScreen({super.key, this.programId});

  @override
  State<ActivateMembershipScreen> createState() =>
      _ActivateMembershipScreenState();
}

class _ActivateMembershipScreenState extends State<ActivateMembershipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '####-#######',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _cedulaMaskFormatter = MaskTextInputFormatter(
    mask: '##########',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedBank = 'Mercantil';
  bool _isProcessing = false;

  final List<String> _banks = [
    'Mercantil',
    'Banesco',
    'Venezuela',
    'Provincial',
    'BNC',
    'Bicentenario',
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _cedulaController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Program? _getProgram() {
    if (widget.programId == null) return null;
    try {
      return Program.mockList().firstWhere(
        (p) => p.id == widget.programId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simular validación del pago
    await Future.delayed(const Duration(seconds: 2));

    try {
      final userService = context.read<UserService>();
      final currentUser = userService.user!;
      
      // Agregar el programa a las membresías activas del usuario
      if (widget.programId != null) {
        final updatedMemberships = [
          ...currentUser.activeMemberships,
          widget.programId!,
        ];
        
        final updatedUser = currentUser.copyWith(
          activeMemberships: updatedMemberships,
          updatedAt: DateTime.now(),
        );
        
        userService.setUser(updatedUser);
      }

      if (mounted) {
        // Mostrar diálogo de éxito
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: ColorPalette.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: ColorPalette.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 48,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '¡Pago Registrado!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tu pago está en revisión. Serás notificado cuando sea aprobado.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Entendido',
                  onPressed: () {
                    Navigator.pop(context); // Cerrar diálogo
                    Navigator.pop(context); // Volver a la pantalla anterior
                  },
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar pago: $e'),
            backgroundColor: ColorPalette.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final program = _getProgram();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activar Membresía'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del programa
              if (program != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: ColorPalette.cardGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        program.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total a pagar:',
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorPalette.textSecondary,
                            ),
                          ),
                          Text(
                            '\$${program.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Título
              const Text(
                'Datos del Pago Móvil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Banco
              DropdownButtonFormField<String>(
                initialValue: _selectedBank,
                decoration: const InputDecoration(
                  labelText: 'Banco',
                  prefixIcon: Icon(Icons.account_balance),
                ),
                items: _banks.map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedBank = value!);
                },
              ),
              const SizedBox(height: 16),

              // Teléfono
              TextFormField(
                controller: _phoneController,
                inputFormatters: [_phoneMaskFormatter],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone_android),
                  hintText: '0412-1234567',
                ),
                validator: Validators.phoneVenezuela,
              ),
              const SizedBox(height: 16),

              // Cédula
              TextFormField(
                controller: _cedulaController,
                inputFormatters: [_cedulaMaskFormatter],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  prefixIcon: Icon(Icons.badge),
                  hintText: 'V-12345678',
                ),
                validator: Validators.cedulaVenezuela,
              ),
              const SizedBox(height: 16),

              // Referencia
              TextFormField(
                controller: _referenceController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Número de Referencia',
                  prefixIcon: Icon(Icons.confirmation_number),
                  hintText: '123456',
                ),
                validator: (value) =>
                    Validators.required(value, fieldName: 'La referencia'),
              ),
              const SizedBox(height: 24),

              // Fecha del pago
              const Text(
                'Fecha del Pago',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: ColorPalette.cardGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 7)),
                  lastDay: DateTime.now(),
                  focusedDay: _selectedDate,
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.week,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: ColorPalette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: ColorPalette.textSecondary),
                    weekendStyle: TextStyle(color: ColorPalette.textSecondary),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: ColorPalette.primary.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      gradient: ColorPalette.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    todayTextStyle: const TextStyle(
                      color: ColorPalette.textPrimary,
                    ),
                    defaultTextStyle: const TextStyle(
                      color: ColorPalette.textSecondary,
                    ),
                    weekendTextStyle: const TextStyle(
                      color: ColorPalette.textSecondary,
                    ),
                    outsideTextStyle: const TextStyle(
                      color: ColorPalette.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón de envío
              CustomButton(
                text: _isProcessing ? 'Procesando...' : 'Registrar Pago',
                onPressed: _isProcessing ? null : _submitPayment,
                isLoading: _isProcessing,
                icon: Icons.payment,
              ),
              const SizedBox(height: 16),

              // Nota informativa
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorPalette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorPalette.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ColorPalette.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Tu pago será verificado en las próximas 24 horas. Recibirás una notificación cuando tu membresía esté activa.',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorPalette.textSecondary,
                          height: 1.5,
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
    );
  }
}
