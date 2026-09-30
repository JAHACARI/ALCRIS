import 'package:alcris/screen/resumenreserva.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/paquete/cabecera.dart';
import 'package:alcris/widgets/datosreserva/calendario.dart';
import 'package:alcris/widgets/datosreserva/horas.dart';

class AgendarCitaScreen extends StatefulWidget {
  final Map<String, dynamic> datosRecopilados;

  const AgendarCitaScreen({super.key, required this.datosRecopilados});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final int _currentIndex = 2; // "Servicios" seleccionado en tu barra inferior
  String _fechaSeleccionada = '11 de Julio, 2026';
  String _horaSeleccionadaString = '8:00 AM';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // 1. Cabecera azul corporativa adaptada con tus textos de la imagen
          const CabeceraDetalle(
            titulo: 'Agenda tu cita',
            subtitulo: 'cuida tu tiempo con nosotros',
            icono: Icons.directions_car_filled_rounded,
          ),

          // Contenido Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FECHA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Componente del Calendario
                  SelectorCalendario(
                    onFechaSeleccionada: (nuevaFecha) {
                      setState(() {
                        _fechaSeleccionada =
                            nuevaFecha; // Actualiza el string que viajará al resumen
                      });
                    },
                  ),
                  const Text(
                    'HORA DISPONIBLE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Componente de bloques de horario
                  SelectorHoras(
                    onHoraSeleccionada: (nuevaHora) {
                      setState(() {
                        _horaSeleccionadaString =
                            nuevaHora; // Captura el string dinámico
                      });
                    },
                  ),

                  // 4. Botón Continuar de Confirmación con Degradado Lineal
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE94560), Color(0xFFC0392B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResumenReservaScreen(
                            datosReserva: {
                              ...widget
                                  .datosRecopilados, // Mantiene el servicio y el paquete previo
                              'fecha':
                                  _fechaSeleccionada, // Envía la fecha guardada
                              'hora':
                                  _horaSeleccionadaString, // Envía la hora guardada (¡Quita el error!)
                            },
                          ),
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
