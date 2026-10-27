import 'package:flutter/material.dart';
import '../../services/admin_api.dart';
import '../../models/servicio.dart';

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});
  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  late Future<List<ReservaAdmin>> _f = AdminApi.reservas();
  void _reload() => setState(() => _f = AdminApi.reservas());

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _cambiarEstado(ReservaAdmin r) async {
    final List<String> estados;
    try {
      estados = await AdminApi.estados();
    } on AdminApiError catch (e) {
      _msg(e.message);
      return;
    }
    if (!mounted) return;
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Estado de ${r.codigo}'),
        children: [
          for (final e in estados)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, e),
              child: Text(
                e,
                style: TextStyle(
                  fontWeight: e == r.estado ? FontWeight.w800 : FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
    if (nuevo == null || nuevo == r.estado) return;
    try {
      await AdminApi.cambiarEstado(r.id, nuevo);
      _msg('Estado actualizado');
      _reload();
    } on AdminApiError catch (e) {
      _msg(e.message);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ReservaAdmin>>(
    future: _f,
    builder: (_, snap) {
      if (snap.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snap.hasError) return Center(child: Text('${snap.error}'));
      final list = snap.data!;
      if (list.isEmpty) return const Center(child: Text('No hay reservas.'));
      return RefreshIndicator(
        onRefresh: () async => _reload(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final r = list[i];
            return Card(
              child: ListTile(
                title: Text(
                  '${r.codigo} · ${r.servicio}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${r.cliente}\n${r.vehiculo}\n${r.fecha} ${r.hora} · ${cop(r.total)}',
                ),
                isThreeLine: true,
                trailing: ActionChip(
                  label: Text(r.estado),
                  onPressed: () => _cambiarEstado(r),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
