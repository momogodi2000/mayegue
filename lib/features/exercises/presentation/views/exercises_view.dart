import 'package:flutter/material.dart';

class ExercicePage extends StatelessWidget {
  const ExercicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercices")),
      body: const Center(
        child: Text(
          "✍️ Exercices interactifs",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
