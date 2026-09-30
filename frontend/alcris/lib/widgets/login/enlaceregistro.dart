import 'package:flutter/material.dart';
import 'package:alcris/screen/registro.dart';

class EnlaceRegistro extends StatelessWidget {
  const EnlaceRegistro({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegistroScreen(),
        ),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF1E293B),
          ),
          children: [
            TextSpan(text: '¿No tienes cuenta?  '),
            TextSpan(
              text: 'Crea una',
              style: TextStyle(
                color: Color(0xFFE94560),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}