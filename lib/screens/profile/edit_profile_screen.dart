import 'package:flutter/material.dart';

// TODO: Implementar edición de perfil
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: const Center(child: Text('Formulario de edición de perfil')),
    );
  }
}
