import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color.fromARGB(255, 5, 80, 142);
  static const Color secondary = Color.fromARGB(255, 10, 46, 102);

  // Pantalla de carga estilo Netflix (desde alcris-janier)
  static const Color fondoOscuro = Color(0xFF000000);
  static const Color blancoTexto = Color(0xFFFFFFFF);
  static const Color letraBlue = Color(0xFF0066FF);
  static const Color letraRed = Color(0xFFFF0000);

  static const Gradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
