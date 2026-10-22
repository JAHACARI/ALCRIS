import 'package:alcris/screen/servicios/agendarcita.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/paquete/cabecera.dart';
import 'package:alcris/widgets/paquete/tarjetapaquete.dart';

class DetalleServiciolav extends StatefulWidget {
  final Map<String, dynamic> servicio;

  const DetalleServiciolav({super.key, required this.servicio});

  @override
  State<DetalleServiciolav> createState() => _DetalleServicioScreenState();
}

class _DetalleServicioScreenState extends State<DetalleServiciolav> {
  int _paqueteSeleccionado = 0;

   final List<Map<String, dynamic>> _paquetes = [
    {
      'nombre': 'Interiores',
      'descripcion': 'Evaluamos a detalle el estado de los componentes internos, tapicería y sistemas de seguridad pasiva para garantizar una reparación integral y estética de la cabina.',
      'paneles': 'Componentes internos', // <- Agregado para que tu componente lo pinte en negrita
      'tiempo': '2 horas',
      'precio': '\$70.000',
      'tag': 'Popular',
      'tagBg': const Color(0xFFFFF0F2),    
      'tagColor': const Color(0xFFFF4D6D), 
      'colorTitle': const Color(0xFF2B2B2B),
    },
    {
      'nombre': 'Exteriores',
      'descripcion': 'Evaluamos meticulosamente la carrocería para identificar deformaciones, daños en la pintura y desajustes de piezas, asegurando que tu vehículo recupere su estética y valor original.',
      'paneles': 'Carrocería externa', // <- Agregado para que coincida con tu diseño
      'tiempo': '3 horas', 
      'precio': '\$45.000', 
      'tag': 'Completo',
      'tagBg': const Color(0xFFFFEF3C), // CORREGIDO: De 9 a 6 dígitos hexadecimales válidos
      'tagColor': const Color(0xFFD97706), // CORREGIDO: De 7 a 6 dígitos hexadecimales válidos
      'colorTitle': const Color(0xFF855D28),
    },
    {
      'nombre': 'Combo Full',
      'descripcion': 'Servicio ideal para entregar un carro que acaba de salir de reparación de latonería. Elimina por completo el polvillo de lija y los residuos de grasa por dentro y por fuera.',
      'paneles': 'Limpieza e Inspección Completa', // <- El texto que se verá en negrita abajo en el tercero
      'tiempo': '4 horas', 
      'precio': '\$95.000', 
      'tag': 'Recomendado',
      'tagBg': const Color(0xFFE8F5E9),    
      'tagColor': const Color(0xFF2E7D32), 
      'colorTitle': const Color.fromARGB(255, 43, 201, 167),
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
                    BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 4)),
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
