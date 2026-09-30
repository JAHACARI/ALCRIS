import 'package:flutter/material.dart';
import 'package:alcris/widgets/resumenreserva/desglocecostos.dart';
import 'package:alcris/widgets/resumenreserva/detallereserva.dart';
import 'package:alcris/widgets/resumenreserva/formasdepago.dart';
import 'package:alcris/widgets/menuinferior.dart';

class ResumenReservaScreen extends StatefulWidget {
  final Map<String, dynamic> datosReserva;

  const ResumenReservaScreen({super.key, required this.datosReserva});

  @override
  State<ResumenReservaScreen> createState() => _ResumenReservaScreenState();
}

class _ResumenReservaScreenState extends State<ResumenReservaScreen> {
  final int _currentIndex = 1; // Ajustado al índice de Servicios para tu barra de 4 ítems
  String _metodoPagoSeleccionado = 'Efectivo';

  @override
  Widget build(BuildContext context) {
    // CORRECCIÓN DE LLAVES: Mapeamos los datos asegurando que coincidan con tus pantallas previas
    final Map<String, dynamic> datosAdaptadosCita = {
      'servicio': widget.datosReserva['title'] ?? widget.datosReserva['servicio'] ?? 'Servicio',
      'fecha': widget.datosReserva['fecha'] ?? 'No seleccionada',
      'hora': widget.datosReserva['hora'] ?? 'No seleccionada',
      'encargado': widget.datosReserva['encargado'] ?? 'Por asignar',
      'duracion': widget.datosReserva['tiempo'] ?? widget.datosReserva['duracion'] ?? '1-2 Días',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // --- CABECERA DE RESERVA ---
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF003366), Color(0xFF0055A5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white12, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Resumen de Reserva', 
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  'Revisa los detalles de tu cita antes de confirmar.', 
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
              ],
            ),
          ),

          // --- CONTENIDO SCROLLABLE ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Pasamos los datos perfectamente adaptados sin valores nulos
                  TarjetaCitaDetalle(datosCita: datosAdaptadosCita),
                  const SizedBox(height: 16),
                  
                  // Desglose dinámico de costos (usa valores por defecto si vienen vacíos de la API)
                  DesgloseCostos(
                    servicioBasico: widget.datosReserva['costo_basico'] ?? '\$80.000',
                    materiales: widget.datosReserva['costo_materiales'] ?? '\$15.000',
                    descuento: widget.datosReserva['costo_descuento'] ?? '-\$10.000',
                    total: widget.datosReserva['costo_total'] ?? '\$90.000',
                  ),
                  const SizedBox(height: 20),
                  
                  SelectorPago(onMetodoSeleccionado: (metodo) => _metodoPagoSeleccionado = metodo),
                  const SizedBox(height: 28),

                  // --- BOTÓN CONFIRMAR RESERVA ---
                  Container(
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
                        BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí enviarías el mapa 'widget.datosReserva' definitivo a tu backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('¡Reserva confirmada con éxito!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, 
                        shadowColor: Colors.transparent, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'CONFIRMAR RESERVA', 
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: MenuInferior(
        currentIndex: _currentIndex, 
        onTap: (i) {
          // Permite que el menú inferior te regrese a las pantallas principales del IndexedStack
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }
}