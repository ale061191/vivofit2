import 'package:flutter/material.dart';

// TODO: Implementar pantalla de detalle de programa
class ProgramDetailScreen extends StatelessWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Programa')),
      body: Center(child: Text('Program ID: $programId')),
    );
  }
}
