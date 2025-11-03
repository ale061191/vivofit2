import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivofit/components/custom_button.dart';
import 'package:vivofit/services/user_service.dart';
import 'package:vivofit/theme/app_theme.dart';
import 'package:vivofit/theme/color_palette.dart';
import 'package:vivofit/utils/validators.dart';

/// Pantalla de Edición de Perfil
/// Permite al usuario actualizar sus datos personales y foto de perfil
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  File? _selectedImage;
  bool _isSaving = false;

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserService>().user;

    _nameController = TextEditingController(text: user?.name ?? '');
    _ageController = TextEditingController(
      text: user?.age?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: user?.height?.toStringAsFixed(0) ?? '',
    );
    _weightController = TextEditingController(
      text: user?.weight?.toStringAsFixed(1) ?? '',
    );
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
    _selectedGender = user?.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: ColorPalette.error,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorPalette.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: ColorPalette.primary),
              title: const Text(
                'Tomar foto',
                style: TextStyle(color: ColorPalette.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: ColorPalette.primary),
              title: const Text(
                'Elegir de galería',
                style: TextStyle(color: ColorPalette.textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final userService = context.read<UserService>();
      final currentUser = userService.user!;

      // En producción, aquí se subiría la imagen al servidor
      // Por ahora solo guardamos los datos localmente
      final updatedUser = currentUser.copyWith(
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        height: double.tryParse(_heightController.text.trim()),
        weight: double.tryParse(_weightController.text.trim()),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        gender: _selectedGender,
        updatedAt: DateTime.now(),
      );

      userService.setUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado exitosamente'),
            backgroundColor: ColorPalette.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: ColorPalette.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserService>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto de perfil
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: ColorPalette.cardBackgroundLight,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) as ImageProvider
                        : user?.photoUrl != null
                            ? NetworkImage(user!.photoUrl!) as ImageProvider
                            : null,
                    child: _selectedImage == null && user?.photoUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: ColorPalette.textTertiary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: ColorPalette.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Campo Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    Validators.required(value, fieldName: 'El nombre'),
              ),
              const SizedBox(height: 16),

              // Fila: Edad y Género
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Edad',
                        prefixIcon: Icon(Icons.cake_outlined),
                        suffixText: 'años',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Género',
                        prefixIcon: Icon(Icons.person_pin_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'male', child: Text('Masculino')),
                        DropdownMenuItem(
                            value: 'female', child: Text('Femenino')),
                        DropdownMenuItem(value: 'other', child: Text('Otro')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedGender = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Fila: Altura y Peso
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Altura',
                        prefixIcon: Icon(Icons.height),
                        suffixText: 'cm',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Peso',
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                        suffixText: 'kg',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campo Teléfono
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '+58 412-1234567',
                ),
              ),
              const SizedBox(height: 16),

              // Campo Ubicación
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: 'Ciudad, País',
                ),
              ),
              const SizedBox(height: 32),

              // Botón Guardar
              CustomButton(
                text: _isSaving ? 'Guardando...' : 'Guardar Cambios',
                onPressed: _isSaving ? null : _saveProfile,
                isLoading: _isSaving,
              ),
              const SizedBox(height: 16),

              // Botón Cancelar
              CustomButton(
                text: 'Cancelar',
                isOutlined: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
