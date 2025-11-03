import 'package:flutter/material.dart';

// TODO: Implementar activación de membresía
class ActivateMembershipScreen extends StatelessWidget {
  final String? programId;

  const ActivateMembershipScreen({super.key, this.programId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activar Membresía')),
      body: Center(child: Text('Program ID: ${programId ?? "None"}')),
    );
  }
}
