import 'package:flutter/material.dart';
import '../../services/admin_api.dart';
import '../../models/servicio.dart';

class ServiciosPage extends StatefulWidget {
  const ServiciosPage({super.key});
  @override
  State<ServiciosPage> createState() => _ServiciosPageState();
}

class _ServiciosPageState extends State<ServiciosPage> {
  late Future<List<ServicioAdmin>> _f = AdminApi.servicios();
  void _reload() => setState(() => _f = AdminApi.servicios());

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _abrirForm([ServicioAdmin? s]) async {
    final tema = Theme.of(context); // conserva los colores del panel en la pantalla nueva
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => Theme(data: tema, child: ServicioFormPage(servicio: s))),
    );
    if (ok == true) {
      _msg(s == null ? 'Servicio creado' : 'Servicio actualizado');
      _reload();
    }
  }

  Future<void> _borrar(ServicioAdmin s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar servicio'),
        content: Text('Se quitará "${s.nombre}" del catálogo que ven los clientes. '
            'Las reservas anteriores conservan su precio.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar servicio')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await AdminApi.eliminarServicio(s.id);
      _msg('Servicio eliminado');
      _reload();
    } on AdminApiError catch (e) {
      _msg(e.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _abrirForm(), icon: const Icon(Icons.add), label: const Text('Nuevo servicio')),
        body: FutureBuilder<List<ServicioAdmin>>(
          future: _f,
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
            if (snap.hasError) return Center(child: Text('${snap.error}'));
            final list = snap.data!;
            if (list.isEmpty) return const Center(child: Text('No hay servicios. Crea el primero.'));
            return RefreshIndicator(
              onRefresh: () async => _reload(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final s = list[i];
                  return Card(
                    child: ListTile(
                      title: Text(s.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        '${s.descripcion}\n'
                        '${s.paquetes.isEmpty ? 'Sin paquetes: edítalo y agrega uno' : 'Desde ${cop(s.precio)} · ${s.paquetes.length} paquete(s)'}',
                      ),
                      isThreeLine: true,
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(icon: const Icon(Icons.edit_outlined), tooltip: 'Editar', onPressed: () => _abrirForm(s)),
                        IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Eliminar', onPressed: () => _borrar(s)),
                      ]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
}

// ───────── Formulario de servicio: el precio se pone en cada paquete ─────────
class _PaqueteCtl {
  final int? id;
  final nombre = TextEditingController();
  final descripcion = TextEditingController();
  final diasMin = TextEditingController();
  final diasMax = TextEditingController();
  final precio = TextEditingController();
  bool destacado = false;
  _PaqueteCtl([PaqueteAdmin? p]) : id = p?.id {
    nombre.text = p?.nombre ?? '';
    descripcion.text = p?.descripcion ?? '';
    diasMin.text = (p?.diasMin ?? 1).toString();
    diasMax.text = (p?.diasMax ?? 1).toString();
    precio.text = p == null ? '' : p.precio.toString();
    destacado = p?.destacado ?? false;
  }
  void dispose() {
    nombre.dispose();
    descripcion.dispose();
    diasMin.dispose();
    diasMax.dispose();
    precio.dispose();
  }
}

class ServicioFormPage extends StatefulWidget {
  final ServicioAdmin? servicio;
  const ServicioFormPage({super.key, this.servicio});
  @override
  State<ServicioFormPage> createState() => _ServicioFormPageState();
}

class _ServicioFormPageState extends State<ServicioFormPage> {
  final _key = GlobalKey<FormState>();
  late final _nombre = TextEditingController(text: widget.servicio?.nombre);
  late final _desc = TextEditingController(text: widget.servicio?.descripcion);
  // Siempre hay al menos un paquete en el formulario
  late final List<_PaqueteCtl> _paq = (widget.servicio?.paquetes.isNotEmpty ?? false)
      ? [for (final p in widget.servicio!.paquetes) _PaqueteCtl(p)]
      : [_PaqueteCtl()];
  bool _busy = false;

  @override
  void dispose() {
    _nombre.dispose();
    _desc.dispose();
    for (final p in _paq) {
      p.dispose();
    }
    super.dispose();
  }

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _guardar() async {
    if (!_key.currentState!.validate()) return;
    final paquetes = [
      for (final c in _paq)
        PaqueteAdmin(
          id: c.id,
          nombre: c.nombre.text.trim(),
          descripcion: c.descripcion.text.trim(),
          precio: int.parse(c.precio.text.trim()),
          diasMin: int.parse(c.diasMin.text.trim()),
          diasMax: int.parse(c.diasMax.text.trim()),
          destacado: c.destacado,
        ),
    ];
    setState(() => _busy = true);
    try {
      final s = widget.servicio;
      s == null
          ? await AdminApi.crearServicio(_nombre.text.trim(), _desc.text.trim(), paquetes)
          : await AdminApi.editarServicio(s.id, _nombre.text.trim(), _desc.text.trim(), paquetes);
      if (mounted) Navigator.pop(context, true);
    } on AdminApiError catch (e) {
      _msg(e.message);
      if (mounted) setState(() => _busy = false);
    }
  }

  String? _obligatorio(String? v) => (v ?? '').trim().isEmpty ? 'Obligatorio' : null;
  String? _precioOk(String? v) => (int.tryParse((v ?? '').trim()) ?? 0) <= 0 ? 'Precio inválido' : null;
  String? _diasOk(String? v) {
    final n = int.tryParse((v ?? '').trim()) ?? 0;
    return (n < 1 || n > 365) ? '1 a 365' : null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.servicio == null ? 'Nuevo servicio' : 'Editar servicio')),
        body: Form(
          key: _key,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre del servicio', border: OutlineInputBorder()),
              maxLength: 40,
              validator: _obligatorio,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _desc,
              decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
              maxLength: 90,
              validator: _obligatorio,
            ),
            const SizedBox(height: 16),
            Row(children: [
              const Expanded(
                child: Text('Paquetes y precios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Agregar paquete'),
                onPressed: _paq.length >= 10 ? null : () => setState(() => _paq.add(_PaqueteCtl())),
              ),
            ]),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Cada paquete tiene su propio precio. El cliente elige uno al reservar.',
                  style: TextStyle(color: Colors.black54, fontSize: 12)),
            ),
            for (var i = 0; i < _paq.length; i++)
              Card(
                margin: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                        child: Text('Paquete ${i + 1}',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Quitar paquete',
                        onPressed: _paq.length <= 1 ? null : () => setState(() => _paq.removeAt(i).dispose()),
                      ),
                    ]),
                    TextFormField(
                      controller: _paq[i].nombre,
                      decoration: const InputDecoration(labelText: 'Nombre (ej. Interiores)'),
                      validator: _obligatorio,
                    ),
                    TextFormField(
                      controller: _paq[i].descripcion,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      maxLines: 3,
                      minLines: 2,
                    ),
                    Row(children: [
                      Expanded(
                        child: TextFormField(
                          controller: _paq[i].diasMin,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Días mín.'),
                          validator: _diasOk,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _paq[i].diasMax,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Días máx.'),
                          validator: _diasOk,
                        ),
                      ),
                    ]),
                    TextFormField(
                      controller: _paq[i].precio,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Precio del paquete (COP)'),
                      validator: _precioOk,
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Destacado (etiqueta "Popular")'),
                      value: _paq[i].destacado,
                      onChanged: (v) => setState(() => _paq[i].destacado = v),
                    ),
                  ]),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: _busy ? null : _guardar,
                child: _busy
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Guardar servicio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      );
}