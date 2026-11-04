import 'package:alcris/screen/servicios/agendarcita.dart';
import 'package:flutter/material.dart';
import 'package:alcris/widgets/paquete/cabecera.dart';
import 'package:alcris/widgets/paquete/tarjetapaquete.dart';
import 'package:alcris/services/api2_servicios.dart';

class DetalleServicioScreen extends StatefulWidget {
  final Map<String, dynamic> servicio;

  const DetalleServicioScreen({super.key, required this.servicio});

  @override
  State<DetalleServicioScreen> createState() => _DetalleServicioScreenState();
}

class _DetalleServicioScreenState extends State<DetalleServicioScreen> {
  int _paqueteSeleccionado = 0;
  final ApiService _apiService = ApiService();
  Future<List<Map<String, dynamic>>>? _futurePaquetes;

  @override
  void initState() {
    super.initState();
    final dynamic servicioId = widget.servicio['id'] ?? 0;
    _futurePaquetes = _apiService.obtenerPaquetes(servicioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futurePaquetes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Error al cargar paquetes reales:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final List<Map<String, dynamic>> paquetesRaw = snapshot.data ?? [];

          return Column(
            children: [
              CabeceraDetalle(
                titulo: widget.servicio['title'] ?? 'Servicio',
                subtitulo: widget.servicio['subtitle'] ?? '',
                icono: widget.servicio['icon'] ?? Icons.build_rounded,
              ),

              Expanded(
                child: paquetesRaw.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay paquetes configurados para este servicio.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ELIGE TU PAQUETE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Selecciona el alcance ideal para tu vehículo y continúa con la reserva.',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 20),

                            ...List.generate(paquetesRaw.length, (index) {
                              final Map<String, dynamic> p = paquetesRaw[index];

                              // Mapeo directo y ultra limpio de la respuesta de Express
                              final Map<String, dynamic> paqueteFormateado = {
                                'id': p['id'],
                                'nombre': p['nombre'],
                                'descripcion': p['descripcion'] ?? '',
                                'precio': p['precio'],
                                'destacado': p['destacado'] ?? false,
                                'tiempo': p['tiempo'] ?? '1 día',
                              };

                              return TarjetaPaquete(
                                datos: paqueteFormateado,
                                isSelected: _paqueteSeleccionado == index,
                                onTap: () => setState(() => _paqueteSeleccionado = index),
                              );
                            }),
                          ],
                        ),
                      ),
              ),

              if (paquetesRaw.isNotEmpty)
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
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final Map<String, dynamic> paqueteElegido = paquetesRaw[_paqueteSeleccionado];

                          final datosAcumulados = <String, dynamic>{
                            ...widget.servicio,
                            'paquete_id': paqueteElegido['id'],
                            'paquete_nombre': paqueteElegido['nombre'],
                            'precio_final': paqueteElegido['precio'],
                            'tiempo': paqueteElegido['tiempo'],
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Continuar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}