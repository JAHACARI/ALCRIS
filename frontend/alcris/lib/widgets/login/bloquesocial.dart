import 'package:flutter/material.dart';
import 'package:alcris/widgets/login/botonsocial.dart';
import 'package:alcris/widgets/login/loginseparador.dart';

class BloqueSocial extends StatelessWidget {
  final VoidCallback onGoogleTap;

  const BloqueSocial({super.key, required this.onGoogleTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const LoginSeparador(),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: BotonSocial(
                icon: Icons.g_mobiledata_rounded,
                label: 'Google',
                iconColor: Colors.black87,
                onTap: onGoogleTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}