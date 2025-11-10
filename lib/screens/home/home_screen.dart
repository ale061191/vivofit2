import 'package:flutter/material.dart';
import 'package:vivofit/components/custom_cards.dart';

/// Pantalla de Inicio
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: ListView(
        children: [
          GenericCard(
            title: 'Programa de ejemplo',
            onTap: () {
              // Acción al tocar
            },
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detalle del programa', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          GenericCard(
            title: 'Rutina de ejemplo',
            onTap: () {
              // Acción al tocar
            },
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detalle de la rutina', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
