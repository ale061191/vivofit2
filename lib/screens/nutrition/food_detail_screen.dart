import 'package:flutter/material.dart';

// TODO: Implementar pantalla de detalle de alimento
class FoodDetailScreen extends StatelessWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Alimento')),
      body: Center(child: Text('Food ID: $foodId')),
    );
  }
}
