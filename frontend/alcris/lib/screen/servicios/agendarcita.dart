import 'package:alcris/screen/servicios/resumenreserva.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/paquete/cabecera.dart';
import 'package:alcris/widgets/datosreserva/calendario.dart';
import 'package:alcris/widgets/datosreserva/horas.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendarCitaScreen extends StatefulWidget {
  final Map<String, dynamic> datosRecopilados;

  const AgendarCitaScreen({super.key, required this.datosRecopilados});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  String _fechaSeleccionada = '2026-10-22'; // Formato estándar inicial compatible con la base de datos
  String _horaSeleccionadaString = '8:00 AM';
  bool _isLoading = false;

  // Listas reactivas que guardarán la información de tu base de datos de Supabase
  List<String> _diasCompletamenteOcupados = [];
  List<String> _horasDisponiblesDelDia = ["8:00 AM", "9:00 AM", "2:00 PM", "7:20 AM"]; // Fallback inicial

  @override
  void initState() {
    super.initState();
    // Consulta la disponibilidad inicial para el mes actual (Octubre de 2026)
    _obtenerDisponibilidadBackend(10, 2026);
  }

  // 🛠️ CONEXIÓN CON EL ENDPOINT DE TU BACKEND NODE.JS
  Future<void> _obtenerDisponibilidadBackend(int mes, int anio) async {
    setState(() => _isLoading = true);
    try {
      // Reemplaza con la IP o dominio de tu servidor local de Express
      final url = Uri.parse('http://10.0.2');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _diasCompletamenteOcupados = List<String>.from(data['dias_ocupados']);
          _horasDisponiblesDelDia = List<String>.from(data['horas_disponibles']);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error de sincronización con Supabase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          // 1. Cabecera azul corporativa
          const CabeceraDetalle(
            titulo: 'Agenda tu cita',
            subtitulo: 'cuida tu tiempo con nosotros',
            icono: Icons.directions_car_filled_rounded,
          ),

          // Contenido Scrollable o Loader reactivo
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                : SingleChildScrollView(
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

                        // 2. Componente del Calendario adaptado con parámetros de control
                        SelectorCalendario(
                          diasOcupados: _diasCompletamenteOcupados, // 👈 Pasa la lista de bloqueos
                          onMesCambiado: (mes, anio) {             // 👈 Recarga los datos al cambiar de mes
                            _obtenerDisponibilidadBackend(mes, anio);
                          },
                          onFechaSeleccionada: (nuevaFecha) {
                            setState(() {
                              _fechaSeleccionada = nuevaFecha;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        
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

                        // 3. Componente de bloques de horario conectado a la API
                        SelectorHoras(
                          horasDisponibles: _horasDisponiblesDelDia, // 👈 Filtra las horas dinámicamente
                          onHoraSeleccionada: (nuevaHora) {
                            setState(() {
                              _horaSeleccionadaString = nuevaHora;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

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
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE94560), Color(0xFFC0392B)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResumenReservaScreen(
                                    datosReserva: {
                                      ...widget.datosRecopilados,
                                      'fecha': _fechaSeleccionada,
                                      'hora': _horaSeleccionadaString,
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