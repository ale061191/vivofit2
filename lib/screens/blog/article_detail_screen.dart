import 'package:flutter/material.dart';

// TODO: Implementar pantalla de detalle de artículo
class ArticleDetailScreen extends StatelessWidget {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artículo')),
      body: Center(child: Text('Article ID: $articleId')),
    );
  }
}
