import 'package:flutter/material.dart';
// Importación exacta de tu proyecto
import 'package:alcris/widgets/datosreserva/estiloflechas.dart'; 

class SelectorCalendario extends StatefulWidget {
  // Añadimos el callback para avisarle a la pantalla madre qué día se pulsó
  final Function(String) onFechaSeleccionada;

  const SelectorCalendario({super.key, required this.onFechaSeleccionada});

  @override
  State<SelectorCalendario> createState() => _SelectorCalendarioState();
}

class _SelectorCalendarioState extends State<SelectorCalendario> {
  // Cambiamos a 11 para que arranque seleccionado tal como en tu emulador
  int _diaSeleccionado = 11; 
  final List<String> _diasSemana = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  final List<int> _diasMes = List.generate(27, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BotonFlecha(icon: Icons.arrow_back_ios_new_rounded, onPressed: () {}),
              const Text('Julio 2026', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: 0.5)),
              BotonFlecha(icon: Icons.arrow_forward_ios_rounded, onPressed: () {}),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _diasSemana.map((d) => SizedBox(width: 36, child: Center(child: Text(d, style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.bold))))).toList(),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: Color(0xFFF1F5F9), thickness: 1.2)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _diasMes.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Center(child: Text('30', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 14, fontWeight: FontWeight.w500)));
              }

              final diaActual = _diasMes[index - 1];
              final isSelected = _diaSeleccionado == diaActual;

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _diaSeleccionado = diaActual);
                    // Notifica a la pantalla principal el cambio de fecha real
                    widget.onFechaSeleccionada('$diaActual de Julio, 2026');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected ? const LinearGradient(colors: [Color(0xFFE94560), Color(0xFFC0392B)], begin: Alignment.topCenter, end: Alignment.bottomCenter) : null,
                      boxShadow: [if (isSelected) BoxShadow(color: const Color(0xFFE94560).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Center(
                      child: Text('$diaActual', style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF1E293B), fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600)),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}