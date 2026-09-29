import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primary = Color.fromARGB(255, 5, 80, 142);
  static const Color secondary = Color.fromARGB(255, 10, 46, 102);

  static const Gradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
