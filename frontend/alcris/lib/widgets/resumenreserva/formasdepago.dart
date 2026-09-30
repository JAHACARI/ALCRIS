import 'package:flutter/material.dart';

class SelectorPago extends StatefulWidget {
  final Function(String) onMetodoSeleccionado;
  const SelectorPago({super.key, required this.onMetodoSeleccionado});

  @override
  State<SelectorPago> createState() => _SelectorPagoState();
}

class _SelectorPagoState extends State<SelectorPago> {
  int _metodoActivo = 0; // Efectivo por defecto
  final List<String> _opciones = ['Efectivo', 'Tarjeta', 'Nequi'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Forma de pago', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        Row(
          children: List.generate(_opciones.length, (index) {
            final isSelected = _metodoActivo == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _metodoActivo = index);
                  widget.onMetodoSeleccionado(_opciones[index]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.only(right: index == _opciones.length - 1 ? 0 : 10),
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? const Color(0xFFE94560) : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1),
                  ),
                  child: Center(
                    child: Text(
                      _opciones[index],
                      style: TextStyle(color: isSelected ? const Color(0xFFE94560) : const Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}