import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectorCalendario extends StatefulWidget {
  final List<String> diasOcupados; // Recibe los días bloqueados de Supabase
  final Function(int mes, int anio) onMesCambiado; // Avisa al backend al cambiar de mes
  final ValueChanged<String> onFechaSeleccionada;

  const SelectorCalendario({
    super.key,
    required this.diasOcupados,
    required this.onMesCambiado,
    required this.onFechaSeleccionada,
  });

  @override
  State<SelectorCalendario> createState() => _SelectorCalendarioState();
}

class _SelectorCalendarioState extends State<SelectorCalendario> {
  DateTime _focusedDay = DateTime(2026, 10, 22); // Anclado al mes de tu diseño
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime(2026, 1, 1),
        lastDay: DateTime(2026, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        
        // 🛠️ BLOQUEO REAL: Si el día está en la lista de Supabase, deshabilita el clic
        enabledDayPredicate: (day) {
          final String formateado = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
          return !widget.diasOcupados.contains(formateado);
        },

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          // Devuelve la fecha formateada de forma segura para tu backend
          final String fechaString = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
          widget.onFechaSeleccionada(fechaString);
        },

        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          // Lanza la petición HTTP al cambiar de mes en el calendario
          widget.onMesCambiado(focusedDay.month, focusedDay.year);
        },

        // Mantiene tus estilos limpios de interfaz originales
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
        ),
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
          todayTextStyle: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          selectedDecoration: BoxDecoration(color: Color(0xFFE94560), shape: BoxShape.circle),
        ),

        // 🛠️ DISEÑO DE INHABILITACIÓN: Pinta de gris los días copados del panel administrativo
        calendarBuilders: CalendarBuilders(
          disabledBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Fondo gris suave
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: Colors.grey.shade400, 
                  decoration: TextDecoration.lineThrough, // Tacha el número para indicar "Lleno"
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}