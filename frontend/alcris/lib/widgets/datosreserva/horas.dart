import 'package:flutter/material.dart';

class SelectorHoras extends StatefulWidget {
  // 1. Añadimos el callback obligatorio para avisar el cambio al padre
  final Function(String) onHoraSeleccionada;

  const SelectorHoras({super.key, required this.onHoraSeleccionada});

  @override
  State<SelectorHoras> createState() => _SelectorHorasState();
}

class _SelectorHorasState extends State<SelectorHoras> {
  // Ajustamos a 0 para que coincida con el 8:00 AM seleccionado de tu emulador
  int _horaSeleccionada = 0; 

  final List<String> _horarios = ['8:00 AM', '9:00 AM', '2:00 PM', '7:20 AM'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _horarios.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (context, index) {
        final isSelected = _horaSeleccionada == index;

        return GestureDetector(
          onTap: () {
            setState(() => _horaSeleccionada = index);
            // 2. Notificamos a la pantalla madre el horario string seleccionado
            widget.onHoraSeleccionada(_horarios[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? null : Colors.white,
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFE94560), Color(0xFFC0392B)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.transparent : const Color(0xFFECEFF1),
                width: 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFFE94560).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Center(
              child: Text(
                _horarios[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}