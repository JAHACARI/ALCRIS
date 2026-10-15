import 'package:alcris/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import '../../widgets/chat/chat_header.dart';
import '../../widgets/chat/chat_burbuja.dart';
import '../../widgets/chat/chat_input_field.dart';

/// Junta header + burbujas + input y maneja el estado (como ChatMimosModal en la guía).
class ChatAlcris extends StatefulWidget {
  const ChatAlcris({super.key});

  @override
  State<ChatAlcris> createState() => _ChatAlcrisState();
}

class _ChatAlcrisState extends State<ChatAlcris> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _mensajes = [
    {
      'role': 'bot',
      'text':
          '¡Hola! Bienvenido a Alcris Latonería y Pintura. ¿En qué podemos ayudarte hoy?',
    },
  ];

  bool _cargando = false;

  late final String _sesionId =
      'alcris_cliente_${DateTime.now().millisecondsSinceEpoch}';

  void _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _cargando) return;

    _controller.clear();
    setState(() {
      _mensajes.add({'role': 'user', 'text': texto});
      _cargando = true;
    });
    _scrollHaciaAbajo();

    final respuesta = await ChatService.enviarMensaje(
      texto,
      sesionId: _sesionId,
    );

    if (mounted) {
      setState(() {
        _mensajes.add({'role': 'bot', 'text': respuesta});
        _cargando = false;
      });
      _scrollHaciaAbajo();
    }
  }

  void _scrollHaciaAbajo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1220),
      child: Column(
        children: [
          const ChatHeader(), //parte superior del chat bot
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final item = _mensajes[index];
                return ChatBurbuja(
                  texto: item['text']!,
                  esUsuario: item['role'] == 'user',
                );
              },
            ),
          ),
          if (_cargando)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF7C5CFC),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'El asesor está respondiendo...',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
            ),
          ChatInputField(
            controller: _controller,
            cargando: _cargando,
            onEnviar: _enviarMensaje,
          ),
        ],
      ),
    );
  }
}
