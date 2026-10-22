import 'package:alcris/screen/servicios/agendarcita.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/paquete/cabecera.dart';
import 'package:alcris/widgets/paquete/tarjetapaquete.dart';

class DetalleServiciodi extends StatefulWidget {
  final Map<String, dynamic> servicio;
  const DetalleServiciodi({super.key, required this.servicio});

  @override
  State<DetalleServiciodi> createState() => _DetalleServicioScreenState();
}

class _DetalleServicioScreenState extends State<DetalleServiciodi> {
  int _paqueteSeleccionado = 0;

  // SOLUCIÓN: Agregamos las propiedades 'paneles' y estandarizamos las llaves exigidas por TarjetaPaquete
  final List<Map<String, dynamic>> _paquetes = [
    {
      'nombre': 'Interiores',
      'descripcion': 'Evaluamos a detalle el estado de los componentes internos, tapicería y sistemas de seguridad pasiva para garantizar una reparación integral y estética de la cabina.',
      'tiempo': '2 horas', 
      'precio': '\$35.000', 
      'paneles': 'Componentes internos', // Llave requerida para evitar el error Null
      'tag': 'Popular',
      'tagBg': const Color(0xFFFFEBEE), 
      'tagColor': const Color(0xFFE94560), 
      'colorTitle': const Color(0xFFB32646),
    },
    {
      'nombre': 'Exteriores',
      'descripcion': 'Evaluamos meticulosamente la carrocería para identificar deformaciones, daños en la pintura y desajustes de piezas, asegurando que tu vehículo recupere su estética y valor original.',
      'tiempo': '3 horas', 
      'precio': '\$20.000', 
      'paneles': 'Carrocería externa', // Llave requerida para evitar el error Null
      'tag': 'Completo',
      'tagBg': const Color(0xFFFEF3C7), 
      'tagColor': const Color(0xFFD97706), 
      'colorTitle': const Color(0xFF855D2B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String txtTitulo = (widget.servicio['title'] ?? 'Diagnóstico').toString();
    final String txtSub = (widget.servicio['subtitle'] ?? 'Calidad Premium').toString();
    final IconData iconoHeader = widget.servicio['icon'] is IconData ? widget.servicio['icon'] : Icons.build_rounded;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          CabeceraDetalle(titulo: txtTitulo, subtitulo: txtSub, icono: iconoHeader),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ELIGE TU PAQUETE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 4),
                  const Text('Selecciona el alcance ideal para tu vehículo y continúa con la reserva.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),
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
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity, height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE94560), Color(0xFFC0392B)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    final paquete = _paquetes[_paqueteSeleccionado];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgendarCitaScreen(
                          datosRecopilados: {
                            ...widget.servicio,
                            'paquete_nombre': paquete['nombre'],
                            'descripcion': paquete['descripcion'],
                            'paneles': paquete['paneles'],
                            'tiempo': paquete['tiempo'],
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Continuar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}