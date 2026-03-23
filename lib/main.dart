import 'package:flutter/material.dart';
import 'package:proyecto_final_synquid/pantallas/pantalla_inicio.dart';
import 'package:proyecto_final_synquid/pantallas/pantalla_Welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: pantallas()
    );
  }
}

