import 'package:alcris/screen/agendarcita.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/paquete/cabecera.dart';
import 'package:alcris/widgets/paquete/tarjetapaquete.dart';

class DetalleServicioScreen extends StatefulWidget {
  final Map<String, dynamic> servicio;

  const DetalleServicioScreen({super.key, required this.servicio});

  @override
  State<DetalleServicioScreen> createState() => _DetalleServicioScreenState();
}

class _DetalleServicioScreenState extends State<DetalleServicioScreen> {
  int _paqueteSeleccionado = 0;

  final List<Map<String, dynamic>> _paquetes = [
    {
      'nombre': 'Básico',
      'descripcion': 'reparación de golpes leves, masilla y pintura de zona.',
      'paneles': '1 panel',
      'tiempo': '1-2 días',
      'precio': '\$2.500',
      'tag': 'Popular',
      'tagBg': const Color(0xFFFFEBEE),
      'tagColor': const Color(0xFFE94560),
      'colorTitle': const Color(0xFFB32646),
    },
    {
      'nombre': 'Premium',
      'descripcion': 'latonería completa, pintura total y pulido espejo.',
      'paneles': 'múltiples paneles',
      'tiempo': '3-5 días',
      'precio': '\$6.900',
      'tag': 'Completo',
      'tagBg': const Color(0xFFFEF3C7),
      'tagColor': const Color(0xFFD97706),
      'colorTitle': const Color(0xFF855D2B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // Cabecera azul superior
          CabeceraDetalle(
            titulo: widget.servicio['title'] ?? 'Servicio',
            subtitulo: widget.servicio['subtitle'] ?? '',
            icono: widget.servicio['icon'] ?? Icons.build_rounded,
          ),
          
          // Contenido scrollable restaurado (Soluciona la pantalla en blanco)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ELIGE TU PAQUETE', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Selecciona el alcance ideal para tu vehículo y continúa con la reserva.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  
                  // Bucle que dibuja las tarjetas dinámicamente usando tu componente TarjetaPaquete
                  ...List.generate(_paquetes.length, (index) {
                    return TarjetaPaquete(
                      datos: _paquetes[index],
                      isSelected: _paqueteSeleccionado == index,
                      onTap: () => setState(() => _paqueteSeleccionado = index),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Botón Continuar estilizado con el degradado real de tu diseño
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE94560), Color(0xFFC0392B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final paquete = _paquetes[_paqueteSeleccionado];
                    final datosAcumulados = <String, dynamic>{
                      ...widget.servicio,
                      'paquete_nombre': paquete['nombre'],
                      'descripcion': paquete['descripcion'],
                      'paneles': paquete['paneles'],
                      'tiempo': paquete['tiempo'],
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgendarCitaScreen(
                          datosRecopilados: datosAcumulados,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}