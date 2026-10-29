import 'package:flutter/material.dart';
import '../../services/admin_api.dart';

const _dias = [
  (1, 'Lunes'), (2, 'Martes'), (3, 'Miércoles'), (4, 'Jueves'),
  (5, 'Viernes'), (6, 'Sábado'), (0, 'Domingo'),
];

String _label(String h) {
  final p = h.split(':');
  final hh = int.parse(p[0]);
  return '${hh % 12 == 0 ? 12 : hh % 12}:${p[1]} ${hh >= 12 ? 'PM' : 'AM'}';
}

class HorariosPage extends StatefulWidget {
  const HorariosPage({super.key});
  @override
  State<HorariosPage> createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  late Future<Map<String, dynamic>> _f = AdminApi.horarios();
  void _reload() => setState(() => _f = AdminApi.horarios());

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _bloquear() async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: hoy.add(const Duration(days: 1)),
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 365)),
    );
    if (fecha == null || !mounted) return;
    final motivo = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Bloquear ${_fmt(fecha)}'),
        content: TextField(
          controller: motivo,
          decoration: const InputDecoration(labelText: 'Motivo (opcional)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Bloquear día')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final n = await AdminApi.bloquearDia(_fmt(fecha), motivo.text.trim());
      _msg(n > 0
          ? 'Día bloqueado. Ojo: ya hay $n reserva(s) ese día; revísalas en Reservas.'
          : 'Día bloqueado');
      _reload();
    } on AdminApiError catch (e) {
      _msg(e.message);
    }
  }

  Future<void> _desbloquear(String fecha) async {
    try {
      await AdminApi.desbloquearDia(fecha);
      _msg('Día habilitado');
      _reload();
    } on AdminApiError catch (e) {
      _msg(e.message);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
        future: _f,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('${snap.error}'));
          final semana = Map<String, dynamic>.from(snap.data!['semana']);
          final bloqueados = List<Map<String, dynamic>>.from(
              (snap.data!['bloqueados'] as List).map((e) => Map<String, dynamic>.from(e)));
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Horario semanal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Toca una hora para quitarla, o agrega nuevas. Un día sin horas queda cerrado.',
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 8),
                for (final (dia, nombre) in _dias)
                  _DiaCard(
                    key: ValueKey('$dia-${(semana['$dia'] as List).map((s) => '${s['hora']}${s['cupo']}').join()}'),
                    dia: dia,
                    nombre: nombre,
                    horas: [for (final s in semana['$dia'] as List) s['hora'] as String],
                    cupo: (semana['$dia'] as List).isNotEmpty ? (semana['$dia'] as List).first['cupo'] as int : 1,
                    onSaved: _reload,
                  ),
                const SizedBox(height: 16),
                Row(children: [
                  const Expanded(
                    child: Text('Días bloqueados',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.event_busy),
                    label: const Text('Bloquear día'),
                    onPressed: _bloquear,
                  ),
                ]),
                if (bloqueados.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No hay días bloqueados.'),
                  ),
                for (final b in bloqueados)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.event_busy),
                      title: Text(b['fecha'] as String),
                      subtitle: (b['motivo'] ?? '').toString().isEmpty ? null : Text(b['motivo']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Habilitar de nuevo',
                        onPressed: () => _desbloquear(b['fecha'] as String),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      );
}

class _DiaCard extends StatefulWidget {
  final int dia, cupo;
  final String nombre;
  final List<String> horas;
  final VoidCallback onSaved;
  const _DiaCard({super.key, required this.dia, required this.nombre,
      required this.horas, required this.cupo, required this.onSaved});
  @override
  State<_DiaCard> createState() => _DiaCardState();
}

class _DiaCardState extends State<_DiaCard> {
  late List<String> _horas = [...widget.horas];
  late int _cupo = widget.cupo;
  bool _busy = false;

  bool get _cambio =>
      _cupo != widget.cupo || _horas.join(',') != widget.horas.join(',');

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _agregar() async {
    final t = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 8, minute: 0));
    if (t == null) return;
    final h = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    if (!_horas.contains(h)) setState(() => _horas = ([..._horas, h]..sort()));
  }

  Future<void> _guardar() async {
    setState(() => _busy = true);
    try {
      await AdminApi.guardarDia(widget.dia, _horas, _cupo);
      _msg('${widget.nombre} actualizado');
      widget.onSaved();
    } on AdminApiError catch (e) {
      _msg(e.message);
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(widget.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              if (_horas.isEmpty)
                const Chip(label: Text('Cerrado'), visualDensity: VisualDensity.compact),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 4, children: [
              for (final h in _horas)
                InputChip(
                  label: Text(_label(h)),
                  onDeleted: () => setState(() => _horas = _horas.where((x) => x != h).toList()),
                ),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('Hora'),
                onPressed: _agregar,
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Reservas por hora: '),
              DropdownButton<int>(
                value: _cupo,
                items: [for (var i = 1; i <= 5; i++) DropdownMenuItem(value: i, child: Text('$i'))],
                onChanged: (v) => setState(() => _cupo = v!),
              ),
              const Spacer(),
              FilledButton(
                onPressed: (_cambio && !_busy) ? _guardar : null,
                child: const Text('Guardar'),
              ),
            ]),
          ]),
        ),
      );
}