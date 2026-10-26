import 'package:flutter/material.dart';
import '../../services/admin_api.dart';

class ServiciosPage extends StatefulWidget {
  const ServiciosPage({super.key});
  @override
  State<ServiciosPage> createState() => _ServiciosPageState();
}

class _ServiciosPageState extends State<ServiciosPage> {
  late Future<dynamic> _f = AdminApi.servicios();
  void _reload() => setState(() => _f = AdminApi.servicios());

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _form([dynamic s]) async {
    final n = TextEditingController(text: s?.nombre);
    final d = TextEditingController(text: s?.descripcion);
    final p = TextEditingController(text: s?.precio.toString());
    final key = GlobalKey<FormState>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s == null ? 'Nuevo servicio' : 'Editar servicio'),
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: n,
                decoration: const InputDecoration(labelText: 'Nombre'),
                maxLength: 40,
                validator: (v) => v!.trim().isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                controller: d,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLength: 90,
                validator: (v) => v!.trim().isEmpty ? 'Obligatorio' : null,
              ),
              TextFormField(
                controller: p,
                decoration: const InputDecoration(labelText: 'Precio (COP)'),
                keyboardType: TextInputType.number,
                validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0
                    ? 'Precio inválido'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (key.currentState!.validate()) Navigator.pop(context, true);
            },
            child: const Text('Guardar servicio'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final precio = int.parse(p.text);
      s == null
          ? await AdminApi.crearServicio(n.text.trim(), d.text.trim(), precio)
          : await AdminApi.editarServicio(
              s.id,
              n.text.trim(),
              d.text.trim(),
              precio,
            );
      _msg(s == null ? 'ServicioAdmin creado' : 'ServicioAdmin actualizado');
      _reload();
    } on AdminApiError catch (e) {
      _msg(e.message);
    }
  }

  Future<void> _borrar(dynamic s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar servicio'),
        content: Text(
          'Se quitará "${s.nombre}" del catálogo que ven los clientes. '
          'Las reservas anteriores conservan su precio.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar servicio'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await AdminApi.eliminarServicio(s.id);
      _msg('ServicioAdmin eliminado');
      _reload();
    } on AdminApiError catch (e) {
      _msg(e.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => _form(),
      icon: const Icon(Icons.add),
      label: const Text('Nuevo servicio'),
    ),
    body: FutureBuilder<dynamic>(
      future: _f,
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done)
          return const Center(child: CircularProgressIndicator());
        if (snap.hasError) return Center(child: Text('${snap.error}'));
        final list = snap.data!;
        if (list.isEmpty)
          return const Center(
            child: Text('No hay servicios. Crea el primero.'),
          );
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
                  title: Text(
                    s.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text('${s.descripcion}\nCOP ${s.precio}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Editar',
                        onPressed: () => _form(s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Eliminar',
                        onPressed: () => _borrar(s),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
