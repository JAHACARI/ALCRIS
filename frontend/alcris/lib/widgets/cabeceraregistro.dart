import 'package:flutter/material.dart';

class CabeceraRegistro extends StatelessWidget {
  final String titulo;
  const CabeceraRegistro({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF003366), Color(0xFF0055A5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Column(
        children: [
          // Logo Oficial centrado en la parte superior
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/images/logo.jpg', width: 85, height: 85, fit: BoxFit.contain),
          ),
          const SizedBox(height: 12),
          // Título de la pantalla (Crear Cuenta)
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
            ),
          ),
        ],
      ),
    );
  }
}