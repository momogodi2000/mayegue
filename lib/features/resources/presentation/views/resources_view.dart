import 'package:flutter/material.dart';

class RessourcesPage extends StatelessWidget {
  const RessourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ressources")),
      body: const Center(
        child: Text(
          "📚 Liste des ressources pédagogiques",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

