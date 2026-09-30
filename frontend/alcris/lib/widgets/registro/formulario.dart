import 'package:flutter/material.dart';
import 'package:alcris/widgets/camposdetexto.dart';

class FormularioRegistro extends StatelessWidget {
  final List<Map<String, dynamic>> campos;
  final bool aceptoValue;
  final ValueChanged<bool> onAceptoChanged;

  const FormularioRegistro({
    super.key,
    required this.campos,
    required this.aceptoValue,
    required this.onAceptoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ...campos.map((c) => CampoTexto(config: c)),
          Row(
            children: [
              Checkbox(
                value: aceptoValue,
                activeColor: Colors.redAccent,
                onChanged: (v) => onAceptoChanged(v ?? false),
              ),
              const Text('Acepto los ', style: TextStyle(fontSize: 12)),
              const Text(
                'términos y condiciones',
                style: TextStyle(
                  fontSize: 12, 
                  color: Colors.redAccent, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}