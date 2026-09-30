import 'package:flutter/material.dart';
import 'package:alcris/screen/login.dart';

class EnlaceLogin extends StatelessWidget {
  const EnlaceLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
          children: [
            TextSpan(text: '¿Ya tienes cuenta? \n'),
            TextSpan(
              text: 'inicia sesión aquí',
              style: TextStyle(
                color: Colors.redAccent, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}