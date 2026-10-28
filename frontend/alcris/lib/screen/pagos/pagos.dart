import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alcris/models/servicio.dart' show cop;
import 'package:alcris/services/api_pagos.dart';

// ⚠️ Cambia por el número de Nequi real del taller
const kNumeroNequi = '300 000 0000';
const _rojo = Color(0xFFE94560);

// ───────── Lista de reservas por pagar ─────────
class MisPagosScreen extends StatefulWidget {
  const MisPagosScreen({super.key});
  @override
  State<MisPagosScreen> createState() => _MisPagosScreenState();
}

class _MisPagosScreenState extends State<MisPagosScreen> {
  late Future<List<ReservaPago>> _f = PagoApi.misReservas();
  void _reload() => setState(() => _f = PagoApi.misReservas());

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(title: const Text('Mis pagos')),
        body: FutureBuilder<List<ReservaPago>>(
          future: _f,
          builder: (_, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) return Center(child: Text('${snap.error}'));
            final list = snap.data!;
            if (list.isEmpty) {
              return const Center(child: Text('No tienes reservas pendientes de pago.'));
            }
            return RefreshIndicator(
              onRefresh: () async => _reload(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final r = list[i];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${r.codigo} · ${r.servicio}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('${r.fecha} ${r.hora}'),
                        Text('Total: ${cop(r.total)}',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        if (r.enRevision)
                          const Chip(
                            avatar: Icon(Icons.hourglass_top, size: 16),
                            label: Text('Comprobante en revisión'),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(backgroundColor: _rojo),
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Subir comprobante'),
                              onPressed: () async {
                                final ok = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(builder: (_) => SubirComprobanteScreen(reserva: r)),
                                );
                                if (ok == true) _reload();
                              },
                            ),
                          ),
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

// ───────── Subir comprobante ─────────
class SubirComprobanteScreen extends StatefulWidget {
  final ReservaPago reserva;
  const SubirComprobanteScreen({super.key, required this.reserva});
  @override
  State<SubirComprobanteScreen> createState() => _SubirComprobanteScreenState();
}

class _SubirComprobanteScreenState extends State<SubirComprobanteScreen> {
  final _ref = TextEditingController();
  late final _monto = TextEditingController(text: widget.reserva.total.toString());
  final _picker = ImagePicker();
  File? _foto;
  bool _enviando = false;

  @override
  void dispose() {
    _ref.dispose();
    _monto.dispose();
    super.dispose();
  }

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _elegir(ImageSource origen) async {
    final x = await _picker.pickImage(source: origen, imageQuality: 70, maxWidth: 1600);
    if (x != null) setState(() => _foto = File(x.path));
  }

  Future<void> _enviar() async {
    final monto = int.tryParse(_monto.text.trim()) ?? 0;
    if (_foto == null) return _msg('Adjunta la foto del comprobante');
    if (_ref.text.trim().isEmpty) return _msg('Escribe la referencia de Nequi');
    if (monto <= 0) return _msg('Monto inválido');

    setState(() => _enviando = true);
    try {
      await PagoApi.subir(
        reservaId: widget.reserva.id,
        monto: monto,
        ref: _ref.text.trim(),
        foto: _foto!,
      );
      if (!mounted) return;
      _msg('Comprobante enviado. Lo revisaremos pronto.');
      Navigator.pop(context, true);
    } on PagoApiError catch (e) {
      _msg(e.message);
    } catch (_) {
      _msg('No se pudo conectar con el servidor');
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reserva;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: Text('Pagar ${r.codigo}')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // Instrucciones de pago
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF003366), Color(0xFF0055A5)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Paga por Nequi',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              const Text(kNumeroNequi,
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white70, size: 20),
                tooltip: 'Copiar número',
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: kNumeroNequi));
                  _msg('Número copiado');
                },
              ),
            ]),
            Text('Monto a pagar: ${cop(r.total)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Después de pagar, sube la captura del comprobante.',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 16),

        // Vista previa de la foto
        GestureDetector(
          onTap: () => _elegir(ImageSource.gallery),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: _foto == null
                ? const Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 42, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Toca para adjuntar el comprobante', style: TextStyle(color: Colors.grey)),
                    ]),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(_foto!, fit: BoxFit.contain),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('Cámara'),
              onPressed: () => _elegir(ImageSource.camera),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Galería'),
              onPressed: () => _elegir(ImageSource.gallery),
            ),
          ),
        ]),
        const SizedBox(height: 16),

        TextField(
          controller: _ref,
          decoration: const InputDecoration(
            labelText: 'Referencia de Nequi',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _monto,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Monto enviado (COP)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 50,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _rojo),
            onPressed: _enviando ? null : _enviar,
            child: _enviando
                ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Enviar comprobante',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }
}