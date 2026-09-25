import 'package:flutter/material.dart';

class LoginSeparador extends StatelessWidget {
  const LoginSeparador({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.white24, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'O INICIA CON',
            style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Divider(color: Colors.white24, thickness: 1)),
      ],
    );
  }
}