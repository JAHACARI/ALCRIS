import 'package:flutter/material.dart';
import '../../services/admin_api.dart';
import '../../models/servicio.dart';

const _motivos = ['Monto incorrecto', 'Comprobante ilegible', 'PagoAdmin no recibido en Nequi', 'Comprobante duplicado'];

class PagosPage extends StatefulWidget {
  const PagosPage({super.key});
  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  late Future<List<PagoAdmin>> _f = AdminApi.pagos();
  void _reload() => setState(() => _f = AdminApi.pagos());

  @override
  Widget build(BuildContext context) => FutureBuilder<List<PagoAdmin>>(
        future: _f,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('${snap.error}'));
          final list = snap.data!;
          if (list.isEmpty) {
            return const Center(child: Text('No hay comprobantes por revisar.'));
          }
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (_, i) => _PagoCard(pago: list[i], onDone: _reload),
            ),
          );
        },
      );
}

class _PagoCard extends StatefulWidget {
  final PagoAdmin pago;
  final VoidCallback onDone;
  const _PagoCard({required this.pago, required this.onDone});
  @override
  State<_PagoCard> createState() => _PagoCardState();
}

class _PagoCardState extends State<_PagoCard> {
  String _motivo = _motivos.first;
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String ok) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok)));
      widget.onDone();
    } on AdminApiError catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() => _busy = false);
    }
  }

  void _ampliar() => showDialog(
        context: context,
        builder: (_) => Dialog(child: InteractiveViewer(child: Image.network(widget.pago.comprobanteUrl))),
      );

  @override
  Widget build(BuildContext context) {
    final p = widget.pago;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: _ampliar,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(p.comprobanteUrl, height: 220, width: double.infinity, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(height: 120, child: Center(child: Text('No se pudo cargar el comprobante')))),
            ),
          ),
          const SizedBox(height: 12),
          Text(p.cliente, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          Text('${p.referencia} · ${p.servicio}\n${p.vehiculo}'),
          const SizedBox(height: 8),
          Row(children: [
            Text('Monto enviado: ${cop(p.monto)}  ', style: const TextStyle(fontWeight: FontWeight.w700)),
            Chip(
              label: Text(p.coincide ? 'Coincide' : 'Debería ser ${cop(p.precioServicio)}'),
              backgroundColor: p.coincide ? const Color(0xFFDFF5E8) : const Color(0xFFFFF3D1),
              visualDensity: VisualDensity.compact,
            ),
          ]),
          Text('Referencia Nequi: ${p.refNequi}'),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _motivo,
            decoration: const InputDecoration(labelText: 'Motivo si rechazas', isDense: true),
            items: [for (final m in _motivos) DropdownMenuItem(value: m, child: Text(m))],
            onChanged: (v) => setState(() => _motivo = v!),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton(
                onPressed: _busy ? null : () => _run(() => AdminApi.rechazarPago(p.id, _motivo), 'Reserva rechazada'),
                child: const Text('Rechazar')),
            const SizedBox(width: 8),
            FilledButton(
                onPressed: _busy ? null : () => _run(() => AdminApi.aceptarPago(p.id), 'Reserva aceptada'),
                child: const Text('Aceptar reserva')),
          ]),
        ]),
      ),
    );
  }
}
