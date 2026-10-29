import 'package:alcris/screen/servicios/resumenreserva.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/paquete/cabecera.dart';
import 'package:alcris/widgets/datosreserva/calendario.dart';
import 'package:alcris/widgets/datosreserva/horas.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alcris/services/api_config.dart';
import 'package:alcris/services/admin_api.dart';

class AgendarCitaScreen extends StatefulWidget {
  final Map<String, dynamic> datosRecopilados;

  const AgendarCitaScreen({super.key, required this.datosRecopilados});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  late String _fechaSeleccionada;
  String _horaSeleccionadaString = '';
  bool _isLoading = false;

  List<String> _diasCompletamenteOcupados = [];
  // Respaldo si el servidor no responde (mismas horas que el backend)
  List<String> _horasDisponiblesDelDia = [
    '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
    '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
  ];

  String _formatoFecha(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    final ahora = DateTime.now();
    // Por defecto: mañana (nunca una fecha pasada)
    _fechaSeleccionada = _formatoFecha(ahora.add(const Duration(days: 1)));
    _horaSeleccionadaString = _horasDisponiblesDelDia.first;
    _obtenerDisponibilidadBackend(ahora.month, ahora.year, fecha: _fechaSeleccionada);
  }

  Future<void> _obtenerDisponibilidadBackend(int mes, int anio, {String? fecha}) async {
    setState(() => _isLoading = true);
    try {
      final q = 'mes=$mes&anio=$anio${fecha != null ? '&fecha=$fecha' : ''}';
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/reservas/disponibilidad?$q'),
        headers: {'Authorization': 'Bearer ${AdminApi.token}'},
      );

      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        final horas = List<String>.from(data['horas_disponibles'] ?? const []);
        setState(() {
          _diasCompletamenteOcupados =
              List<String>.from(data['dias_ocupados'] ?? const []);
          if (fecha != null) {
            _horasDisponiblesDelDia = horas;
            _horaSeleccionadaString = horas.isNotEmpty ? horas.first : '';
          }
        });
      }
    } catch (e) {
      debugPrint('Error consultando disponibilidad: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continuar() {
    final hoy = _formatoFecha(DateTime.now());
    if (_fechaSeleccionada.compareTo(hoy) < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Elige una fecha que no haya pasado.')),
      );
      return;
    }
    if (_horaSeleccionadaString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay horas disponibles ese día. Elige otra fecha.')),
      );
      return;
    }
    Navigator.push(
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
    );
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

          // Barra de carga fina: el contenido NO se oculta (así el calendario conserva su mes)
          SizedBox(
            height: 3,
            child: _isLoading
                ? const LinearProgressIndicator(color: Colors.redAccent)
                : null,
          ),

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

                  // 2. Calendario
                  SelectorCalendario(
                    diasOcupados: _diasCompletamenteOcupados,
                    onMesCambiado: (mes, anio) {
                      _obtenerDisponibilidadBackend(mes, anio);
                    },
                    onFechaSeleccionada: (nuevaFecha) {
                      setState(() => _fechaSeleccionada = nuevaFecha);
                      final p = nuevaFecha.split('-');
                      if (p.length == 3) {
                        _obtenerDisponibilidadBackend(
                          int.parse(p[1]),
                          int.parse(p[0]),
                          fecha: nuevaFecha,
                        );
                      }
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

                  // 3. Horas del día elegido
                  if (_horasDisponiblesDelDia.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No hay horas disponibles ese día. Elige otra fecha.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    )
                  else
                    SelectorHoras(
                      key: ValueKey(_fechaSeleccionada), // reinicia la selección al cambiar de día
                      horasDisponibles: _horasDisponiblesDelDia,
                      onHoraSeleccionada: (nuevaHora) {
                        setState(() => _horaSeleccionadaString = nuevaHora);
                      },
                    ),
                  const SizedBox(height: 24),

                  // 4. Botón Continuar
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
                      onPressed: _continuar,
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