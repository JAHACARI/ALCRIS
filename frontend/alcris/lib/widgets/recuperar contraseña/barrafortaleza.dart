import 'package:flutter/material.dart';

class BarraFortaleza extends StatefulWidget {
  final Function(String) onCodigoCompleto;
  const BarraFortaleza({super.key, required this.onCodigoCompleto});

  @override
  State<BarraFortaleza> createState() => _BarraFortalezaState();
}

class _BarraFortalezaState extends State<BarraFortaleza> {
  final int _longitudPin = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_longitudPin, (i) => TextEditingController());
    _focusNodes = List.generate(_longitudPin, (i) => FocusNode());

    // Añadimos oyentes a los focos para que redibujen el cuadrito cuando el usuario haga clic en él
    for (var node in _focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _notificarCambio() {
    String codigo = _controllers.map((c) => c.text).join();
    widget.onCodigoCompleto(codigo);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_longitudPin, (index) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controllers[index],
          builder: (context, value, __) {
            final bool tieneTexto = value.text.isNotEmpty;
            final bool estaEnfocado = _focusNodes[index].hasFocus;

            // Determinamos el color de fondo dinámicamente según el estado
            Color colorFondo = const Color(0xFFCBD5E1); // Gris por defecto
            if (tieneTexto) {
              colorFondo = const Color(0xFFF3A3B1); // Rosa si ya tiene número
            } else if (estaEnfocado) {
              colorFondo = Colors.white; // Blanco si el usuario está digitando en él
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 38,
              height: 46,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: colorFondo,
                borderRadius: BorderRadius.circular(10),
                // Si el usuario está parado sobre este cuadrito, le ponemos un borde azul/rojo brillante
                border: Border.all(
                  color: estaEnfocado ? const Color(0xFF0D2C59) : Colors.transparent,
                  width: estaEnfocado ? 2 : 0,
                ),
                boxShadow: [
                  if (estaEnfocado || tieneTexto)
                    BoxShadow(
                      color: const Color.fromARGB(255, 77, 43, 49).withOpacity(0.8),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: tieneTexto ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 2),
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && index < _longitudPin - 1) {
                    _focusNodes[index + 1].requestFocus();
                  }
                  if (val.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  _notificarCambio();
                },
              ),
            );
          },
        );
      }),
    );
  }
}