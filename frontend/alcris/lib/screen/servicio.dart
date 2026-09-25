import 'package:alcris/widgets/servicios/cabeceraazul.dart';
import 'package:alcris/widgets/menuinferior.dart';
import 'package:alcris/widgets/tarjetaservicio.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/menuinferior.dart';
import 'package:alcris/widgets/tarjetaservicio.dart';
import 'package:alcris/widgets/servicios/cabeceraazul.dart'; // Importación recuperada

class PantallaServicios extends StatefulWidget {
  const PantallaServicios({super.key});
  @override
  State<PantallaServicios> createState() => _PantallaServiciosState();
}

class _PantallaServiciosState extends State<PantallaServicios> {
  int _currentIndex = 2; // Inicia en la pestaña de Servicios (Índice 2)

  // Estructura de Datos limpia para alimentar las Tarjetas de Servicio
  final List<Map<String, dynamic>> _servicios = [
    {'title': 'Latonería de precisión', 'subtitle': 'Detallado y pulido', 'desc': 'Reparación y acabado de carrocería con estándares de precisión.', 'icon': Icons.build_rounded, 'color': Colors.redAccent, 'bg': const Color(0xFFFFEBEE)},
    {'title': 'Pintura automotriz', 'subtitle': 'Acabados premium', 'desc': 'Aplicación y acabado con tecnología de gama alta y control de calidad.', 'icon': Icons.brush_rounded, 'color': Colors.blueAccent, 'bg': const Color(0xFFE3F2FD)},
    {'title': 'Lavado de calidad', 'subtitle': 'Externo e interno', 'desc': 'Limpieza profunda con productos de calidad y atención al detalle.', 'icon': Icons.opacity_rounded, 'color': Colors.cyan, 'bg': const Color(0xFFE0F7FA)},
    {'title': 'Diagnóstico', 'subtitle': 'Revisión', 'desc': 'Análisis detallado para identificar necesidades y planificar el trabajo.', 'icon': Icons.search_rounded, 'color': Colors.blueGrey, 'bg': const Color(0xFFECEFF1)},
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> titulos = ['INICIO', 'PERFIL', 'SERVICIOS', 'ASISTENTE CHAT', 'CONFIGURACIÓN'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          CabeceraAzul(titulo: titulos[_currentIndex]),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _buildVistaPlaceholder('Panel de Control Inicial'),
                _buildVistaPlaceholder('Gestión de Perfil de Usuario'),
                _buildGridServicios(), // Carga la vista que mapea tu widget TarjetaServicio
                _buildVistaPlaceholder('Chatbot IA de Alcris'),
                _buildVistaPlaceholder('Ajustes del Sistema'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuInferior(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  // Cuadrícula que utiliza el widget reutilizable "TarjetaServicio" pasándole los mapas de datos
  Widget _buildGridServicios() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nuestros servicios', style: TextStyle(color: Color(0xFF1E293B), fontSize: 18, fontWeight: FontWeight.bold)),
              Row(children: [Icon(Icons.access_time_rounded, size: 16, color: Colors.grey), SizedBox(width: 4), Text('Reserva en línea', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500))]),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.64,
            children: _servicios.map((s) => TarjetaServicio(datos: s)).toList(), // Implementación limpia
          ),
        ],
      ),
    );
  }

  Widget _buildVistaPlaceholder(String mensaje) {
    return Center(
      child: Text(mensaje, style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
    );
  }
}