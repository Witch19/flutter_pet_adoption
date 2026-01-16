import 'package:flutter/material.dart';
import 'package:flu_pet_adoption/navigation/btn_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Adoption',
      home: const BottomNavScreen(),
    );
  }
}
