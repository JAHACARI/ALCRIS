import 'package:flutter/material.dart';
import '../../services/admin_api.dart';
import '../../models/servicio.dart';

class ResumenPage extends StatefulWidget {
  const ResumenPage({super.key});
  @override
  State<ResumenPage> createState() => _ResumenPageState();
}

class _ResumenPageState extends State<ResumenPage> {
  late Future<Map<String, dynamic>> _f = AdminApi.resumen();
  void _reload() => setState(() => _f = AdminApi.resumen());

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
        future: _f,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('${snap.error}'));
          final d = snap.data!;
          final estados = Map<String, dynamic>.from(d['reservasPorEstado'] ?? {});
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _Kpi(Icons.event_note, 'Reservas', '${d['totalReservas']}'),
                    _Kpi(Icons.receipt_long, 'Pagos por revisar', '${d['pagosPendientes']}'),
                    _Kpi(Icons.payments_outlined, 'Ingresos aprobados',
                        cop((d['ingresosAprobados'] as num).toInt())),
                    _Kpi(Icons.build_outlined, 'Servicios activos', '${d['serviciosActivos']}'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Reservas por estado',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Card(
                  child: estados.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16), child: Text('Aún no hay reservas.'))
                      : Column(children: [
                          for (final e in estados.entries)
                            ListTile(
                              dense: true,
                              title: Text(e.key),
                              trailing: Text('${e.value}',
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                            ),
                        ]),
                ),
              ],
            ),
          );
        },
      );
}

class _Kpi extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _Kpi(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              ),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      );
}