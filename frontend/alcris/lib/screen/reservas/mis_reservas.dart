import 'package:flutter/material.dart';

import 'package:alcris/models/reserva_usuario.dart';
import 'package:alcris/services/reserva_api.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen> {
  late Future<List<ReservaUsuario>> _future = ReservaApi.misReservas();

  void _recargar() {
    setState(() => _future = ReservaApi.misReservas());
  }

  Color _colorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'confirmada':
      case 'aprobada':
        return const Color(0xFF2E7D32);
      case 'en_curso':
      case 'en proceso':
        return const Color(0xFF0055A5);
      case 'completada':
        return const Color(0xFF6A1B9A);
      case 'cancelada':
      case 'rechazada':
        return const Color(0xFFC0392B);
      default:
        return const Color(0xFFB26A00);
    }
  }

  String _textoEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'en_curso':
        return 'En curso';
      case 'pendiente':
        return 'Pendiente';
      default:
        return estado.isEmpty ? 'Pendiente' : estado;
    }
  }

  Widget _fila(IconData icono, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(ReservaUsuario reserva) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reserva.codigo.isNotEmpty ? reserva.codigo : 'Reserva',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    _textoEstado(reserva.estado),
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  backgroundColor: _colorEstado(reserva.estado),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _fila(Icons.build_outlined,
                reserva.servicio.isNotEmpty ? reserva.servicio : 'Servicio'),
            if (reserva.vehiculo.isNotEmpty)
              _fila(Icons.directions_car_outlined, reserva.vehiculo),
            _fila(Icons.calendar_today_outlined,
                '${reserva.fechaFormateada} · ${reserva.horaFormateada}'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                Text(
                  reserva.total,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE94560),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Mis reservas'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0B2A6B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<ReservaUsuario>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE94560)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.error}'.replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _recargar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2A6B),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final reservas = snapshot.data ?? <ReservaUsuario>[];

          if (reservas.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => _recargar(),
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.event_available_outlined,
                      size: 64, color: Color(0xFFCBD5E1)),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Aún no tienes reservas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Cuando agendes una cita aparecerá aquí.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _recargar(),
            color: const Color(0xFFE94560),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reservas.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _tarjeta(reservas[index]),
            ),
          );
        },
      ),
    );
  }
}
