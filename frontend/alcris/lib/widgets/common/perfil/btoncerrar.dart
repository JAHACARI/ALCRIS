import 'package:flutter/material.dart';

class BotonCerrarSesion extends StatelessWidget {
  const BotonCerrarSesion({super.key});

  void _ejecutarCerrarSesion(BuildContext context) {
    // Aquí puedes añadir más adelante tu lógica de limpieza de caché o navegación de salida
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sesión cerrada correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton.icon(
        onPressed: () => _ejecutarCerrarSesion(context),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFFF1F2), // Fondo rosa/rojo muy sutil
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFE94560), size: 20),
        label: const Text(
          'Cerrar Sesión',
          style: TextStyle(
            color: Color(0xFFE94560),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}