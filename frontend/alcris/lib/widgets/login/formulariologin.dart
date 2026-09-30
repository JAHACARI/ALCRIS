import 'package:flutter/material.dart';
import 'package:alcris/widgets/camposdetexto.dart';
import 'package:alcris/widgets/login/botonlogin.dart';
import 'package:alcris/widgets/login/logincard.dart';
import 'package:alcris/screen/recuperarcontrase%C3%B1a.dart';

class FormularioLogin extends StatelessWidget {
  final List<Map<String, dynamic>> campos;
  final VoidCallback onLoginPressed;

  const FormularioLogin({
    super.key,
    required this.campos,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LoginCard(
      children: [
        const Center(
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Color(0xFFE94560),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...campos.map((c) => CampoTexto(config: c)),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecuperarScreen(),
              ),
            );
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text(
            'OLVIDASTE TU CONTRASEÑA?',
            style: TextStyle(
              color: Color(0xFFE94560),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        LoginBoton(
          onPressed: onLoginPressed,
        ),
      ],
    );
  }
}