import 'package:flutter/material.dart';
import 'package:systeme_solaire_ar/planetListScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'النظام الشمسي',
      debugShowCheckedModeBanner: false,
      home: PlanetListScreen(),
    );
  }
}
