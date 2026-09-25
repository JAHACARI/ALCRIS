import 'package:alcris/widgets/recuperar%20contrase%C3%B1a/botondegradado.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/camposdetexto.dart';
import 'package:alcris/widgets/recuperar contraseña/botondegradado.dart';

class TarjetaRecuperar extends StatelessWidget {
  const TarjetaRecuperar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEFF8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF3A3B1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.lock_rounded, color: Color(0xFF0F172A), size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  '¿olvidaste tú\ncontraseña?',
                  style: TextStyle(color: const Color(0xFF003366), fontSize: 24, fontWeight: FontWeight.bold, height: 1.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'No te preocupes, te enviaremos intrucciones para recuperarla',
            style: TextStyle(color: const Color(0xFF003366), fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          CampoTexto(config: {
            'label': 'correo electrónico',
            'hint': '@gmail.com',
            'suffix': const Icon(Icons.email_outlined, color: Colors.black87, size: 20),
          }),
          const SizedBox(height: 28),
          BotonDegradado(
            texto: 'enviar código',
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(text: 'Volver  al '),
                  TextSpan(text: 'inicio de sesión', style: TextStyle(color: Color(0xFFE94560), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}