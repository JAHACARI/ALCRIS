import 'package:alcris/widgets/splash/pantalla_carga_alcris.dart';
import 'package:flutter/material.dart';

/// Ejemplo de uso de la pantalla de carga.
class CargaEjemploScreen extends StatelessWidget {
  const CargaEjemploScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PantallaCargaAlcris(
      revealDuration: const Duration(milliseconds: 2200),
      loop: false,
      onComplete: () {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (_) => const PrincipalScreen()),
        // );
        debugPrint('Animación de carga completada');
      },
    );
  }
}
