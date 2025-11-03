import 'package:flutter/material.dart';

// TODO: Implementar pantalla de detalle de rutina con video player
class RoutineDetailScreen extends StatelessWidget {
  final String routineId;

  const RoutineDetailScreen({super.key, required this.routineId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutina')),
      body: Center(child: Text('Routine ID: $routineId')),
    );
  }
}
