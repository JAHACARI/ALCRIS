import 'package:flutter/material.dart';

class SelectorHoras extends StatefulWidget {
  final List<String> horasDisponibles; // Recibe las horas reales enviadas desde Node.js
  final ValueChanged<String> onHoraSeleccionada;

  const SelectorHoras({
    super.key,
    required this.horasDisponibles,
    required this.onHoraSeleccionada,
  });

  @override
  State<SelectorHoras> createState() => _SelectorHorasState();
}

class _SelectorHorasState extends State<SelectorHoras> {
  String? _horaSeleccionada;

  @override
  Widget build(BuildContext context) {
    if (widget.horasDisponibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'No hay horarios configurados para este día.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,       // Grilla de dos columnas como tu mockup original
          childAspectRatio: 2.6,   // Mantiene la proporción geométrica de tus botones
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: widget.horasDisponibles.length,
        itemBuilder: (context, index) {
          final hora = widget.horasDisponibles[index];
          final isSelected = _horaSeleccionada == hora;

          return GestureDetector(
            onTap: () {
              setState(() => _horaSeleccionada = hora);
              widget.onHoraSeleccionada(hora); // Pasa la hora seleccionada al widget padre
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isSelected ? Colors.transparent : Colors.white,
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFE94560), Color(0xFFC0392B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.black12,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                hora,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}