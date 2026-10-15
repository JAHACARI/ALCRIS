import 'package:flutter/material.dart';

/// Mensaje individual (estructura de la guía SENA + estilo oscuro Alcris).
class ChatBurbuja extends StatelessWidget {
  final String texto;
  final bool esUsuario;

  const ChatBurbuja({
    super.key,
    required this.texto,
    required this.esUsuario,
  });

  static const Color _fondoBot = Color(0xFF1A2744);
  static const Color _fondoUsuario = Color(0xFF5C33FF);
  static const Color _textoClaro = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: esUsuario ? _fondoUsuario : _fondoBot,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(esUsuario ? 16 : 4),
            bottomRight: Radius.circular(esUsuario ? 4 : 16),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: _textoClaro,
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
