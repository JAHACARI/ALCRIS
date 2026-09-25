import 'package:flutter/material.dart';


abstract class AppColors {
  static const Color primary = Color.fromARGB(255, 1, 57, 102);
  static const Color secondary = Color.fromARGB(255, 10, 46, 102);
    static const Gradient background = LinearGradient(
    begin: Alignment.topLeft,     // Dónde empieza el degradado
    end: Alignment.bottomRight,   // Dónde termina
    colors: [
      primary,
      secondary,
    ],
  );
}