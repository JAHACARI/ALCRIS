import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alcris/widgets/resumenreserva/desglocecostos.dart';
import 'package:alcris/widgets/resumenreserva/detallereserva.dart';
import 'package:alcris/widgets/resumenreserva/formasdepago.dart';
import 'package:alcris/widgets/common/menuinf2.dart';
import 'package:alcris/services/api_config.dart';
import 'package:alcris/services/admin_api.dart';
import 'package:alcris/services/api_pagos.dart';
import 'package:alcris/screen/pagos/pagos.dart';

class ResumenReservaScreen extends StatefulWidget {
  final Map<String, dynamic> datosReserva;

  const ResumenReservaScreen({super.key, required this.datosReserva});

  @override
  State<ResumenReservaScreen> createState() => _ResumenReservaScreenState();
}

class _ResumenReservaScreenState extends State<ResumenReservaScreen> {
  final int _currentIndex = 1; // Ajustado al índice de Servicios para tu barra de 4 ítems
  String _metodoPagoSeleccionado = 'Efectivo';
  bool _enviando = false;

  String get _urlCrearReserva => '${ApiConfig.baseUrl}/reservas';

  bool get _esTransferencia {
    final m = _metodoPagoSeleccionado.toLowerCase();
    return m.contains('transfer') || m.contains('nequi');
  }

  // Precio real del servicio (el servidor calcula el mismo valor al crear la reserva)
  int? get _precio {
    final p = widget.datosReserva['precio'] ?? widget.datosReserva['precio_base'];
    if (p is num) return p.round();
    if (p is String) return int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), ''));
    return null;
  }

  String _cop(int n) =>
      '\$${n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';

  // "9:00 AM" -> "09:00:00" (formato que espera una columna time)
  String _hora24(String h) {
    final m = RegExp(r'^\s*(\d{1,2}):(\d{2})\s*([AaPp])?\.?[Mm]?\.?\s*$').firstMatch(h);
    if (m == null) return h;
    var hh = int.parse(m.group(1)!);
    final mm = m.group(2)!;
    final ap = m.group(3)?.toLowerCase();
    if (ap == 'p' && hh < 12) hh += 12;
    if (ap == 'a' && hh == 12) hh = 0;
    return '${hh.toString().padLeft(2, '0')}:$mm:00';
  }

  Future<Map<String, dynamic>> _crearReserva() async {
    final d = widget.datosReserva;
    debugPrint('RESERVA datos: ${d.keys.toList()}'); // temporal: ver qué llaves llegan

    final servicioId = d['servicio_id'] ?? d['id'] ?? d['servicioId'];
    if (servicioId == null) {
      throw Exception('No se pudo identificar el servicio. Vuelve a elegirlo.');
    }

    final body = {
      'servicio_id': servicioId,
      'fecha_cita': (d['fecha_cita'] ?? d['fecha']).toString(),
      'hora_cita': _hora24((d['hora_cita'] ?? d['hora']).toString()),
      'forma_pago': _esTransferencia ? 'transferencia' : 'efectivo',
      for (final k in ['vehiculo_id', 'paquete_id', 'color_id', 'acabado_id', 'notas'])
        if (d[k] != null) k: d[k],
    };
    debugPrint('RESERVA body: $body');

    final res = await http.post(
      Uri.parse(_urlCrearReserva),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AdminApi.token}',
      },
      body: jsonEncode(body),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode >= 400) {
      throw Exception(data['error'] ?? data['message'] ?? 'Error ${res.statusCode}');
    }
    return Map<String, dynamic>.from(data['reserva'] ?? data);
  }

  Future<void> _confirmar() async {
    if (_enviando) return;
    setState(() => _enviando = true);
    try {
      final r = await _crearReserva();
      if (!mounted) return;

      if (_esTransferencia) {
        // Transferencia: abre directo la pantalla para subir el comprobante
        final reserva = ReservaPago.fromJson({
          'id': r['id'],
          'codigo': r['codigo_reserva'] ?? r['codigo'] ?? '',
          'total': r['total'] ?? 0,
          'servicio': widget.datosReserva['title'] ?? widget.datosReserva['servicio'] ?? '',
          'fecha': widget.datosReserva['fecha'] ?? '',
          'hora': widget.datosReserva['hora'] ?? '',
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SubirComprobanteScreen(reserva: reserva)),
        );
      } else {
        // Efectivo: queda pendiente hasta que el admin confirme el pago en el taller
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reserva registrada. Pagas en efectivo en el taller.')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

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

    final precio = _precio;
    final txtPrecio = precio != null ? _cop(precio) : 'Por definir';

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
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
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
                  TarjetaCitaDetalle(datosCita: datosAdaptadosCita),
                  const SizedBox(height: 16),

                  // Costos reales: coinciden con lo que cobra el servidor
                  DesgloseCostos(
                    servicioBasico: txtPrecio,
                    materiales: '\$0',
                    descuento: '\$0',
                    total: txtPrecio,
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
                        BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _enviando ? null : _confirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _enviando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
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
      bottomNavigationBar: MenuInferior2(
        currentIndex: _currentIndex,
        onTap: (i) {
          // Permite que el menú inferior te regrese a las pantallas principales del IndexedStack
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }
}