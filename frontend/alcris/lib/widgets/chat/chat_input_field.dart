import 'package:flutter/material.dart';

/// Caja de texto + botón enviar (estructura guía + estilo oscuro).
class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEnviar;
  final bool cargando;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onEnviar,
    required this.cargando,
  });

  static const Color _fondoCampo = Color(0xFF1A2744);
  static const Color _bordeCampo = Color(0xFF2A3A5C);
  static const Color _moradoEnviar = Color(0xFF5C33FF);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _fondoCampo,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _bordeCampo),
              ),
              child: TextField(
                controller: controller,
                enabled: !cargando,
                textInputAction: TextInputAction.send,
                style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14),
                cursorColor: _moradoEnviar,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => onEnviar(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: cargando ? null : onEnviar,
            style: IconButton.styleFrom(
              backgroundColor: cargando
                  ? const Color(0xFF334155)
                  : _moradoEnviar,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              disabledBackgroundColor: const Color(0xFF334155),
            ),
            icon: const Icon(Icons.send_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
