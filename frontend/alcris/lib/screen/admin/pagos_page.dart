import 'package:flutter/material.dart';
import '../../services/admin_api.dart';
import '../../models/servicio.dart';

// Función auxiliar para formatear la moneda
String cop(num monto) =>
    '\$${monto.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

const _motivos = [
  'Monto incorrecto',
  'Comprobante ilegible',
  'PagoAdmin no recibido en Nequi',
  'Comprobante duplicado',
];

class PagosPage extends StatefulWidget {
  const PagosPage({super.key});
  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  late Future<List<PagoAdmin>> _f = AdminApi.pagos();
  void _reload() => setState(() => _f = AdminApi.pagos());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Fondo gris claro moderno para la app
      body: FutureBuilder<List<PagoAdmin>>(
        future: _f,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          final list = snap.data!;

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: CustomScrollView(
              slivers: [
                // 1. Cabecera integrada en el Scroll
                const SliverToBoxAdapter(
                  child: _CabeceraIntegrada(titulo: 'Verificación de Pagos'),
                ),

                // 2. Contenido condicional de la lista
                if (list.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No hay comprobantes por revisar.'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _PagoCard(pago: list[i], onDone: _reload),
                        childCount: list.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- WIDGET REFACTORIZADO DE LA CABECERA ---
class _CabeceraIntegrada extends StatelessWidget {
  final String titulo;
  const _CabeceraIntegrada({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2B48), Color(0xFF0A1E36), Color(0xFF051224)],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Logotipo difuminado en el fondo
          Positioned(
            right: -15,
            top: -10,
            bottom: -10,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  colors: [Colors.transparent, Colors.white],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 190,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox(), // Evita crasheos si no encuentra la imagen
                ),
              ),
            ),
          ),
          // Contenido Principal (Icono + Textos)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 50.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Contenedor del Icono con efecto Glassmorphism
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.18),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons
                        .account_balance_wallet_rounded, // Icono adaptado para Pagos
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                // Textos del Título
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Panel de Administración',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- TARJETA DE CADA COMPROBANTE ---
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
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok)));
      widget.onDone();
    } on AdminApiError catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() => _busy = false);
    }
  }

  void _ampliar() => showDialog(
    context: context,
    builder: (_) => Dialog(
      child: InteractiveViewer(
        child: Image.network(widget.pago.comprobanteUrl),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final p = widget.pago;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _ampliar,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  p.comprobanteUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text('No se pudo cargar el comprobante'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              p.cliente,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Text('${p.referencia} · ${p.servicio}\n${p.vehiculo}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Monto enviado: ${cop(p.monto)}  ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Chip(
                  label: Text(
                    p.coincide
                        ? 'Coincide'
                        : 'Debería ser ${cop(p.precioServicio)}',
                  ),
                  backgroundColor: p.coincide
                      ? const Color(0xFFDFF5E8)
                      : const Color(0xFFFFF3D1),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Text('Referencia Nequi: ${p.refNequi}'),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _motivo,
              decoration: const InputDecoration(
                labelText: 'Motivo si rechazas',
                isDense: true,
              ),
              items: [
                for (final m in _motivos)
                  DropdownMenuItem(value: m, child: Text(m)),
              ],
              onChanged: (v) => setState(() => _motivo = v!),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                          () => AdminApi.rechazarPago(p.id, _motivo),
                          'Reserva rechazada',
                        ),
                  child: const Text('Rechazar'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                          () => AdminApi.aceptarPago(p.id),
                          'Reserva aceptada',
                        ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F2B48),
                  ),
                  child: const Text('Aceptar reserva'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
