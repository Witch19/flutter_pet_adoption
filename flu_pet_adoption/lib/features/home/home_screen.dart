import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pet Adoption Home")),
      body: const Center(
        child: Text("Bienvenido a Pet Adoption"),
      ),
    );
  }
}