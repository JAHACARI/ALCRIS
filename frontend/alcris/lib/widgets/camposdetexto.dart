import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final Map<String, dynamic> config;

  const CampoTexto({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config['label'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextFormField(
          // 👇 ESTA LÍNEA ES LA QUE FALTA PARA CAPTURAR EL TEXTO REAL
          controller: config['controller'] as TextEditingController?, 
          
          obscureText: config['obscure'] ?? false,
          decoration: InputDecoration(
            hintText: config['hint'] ?? '',
            suffixIcon: config['suffix'],
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}