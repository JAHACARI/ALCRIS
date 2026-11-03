import 'package:flutter/material.dart';
import 'package:alcris/services/api2_servicios.dart';
 
class ColoresScreen extends StatefulWidget {
  final Map<String, dynamic> servicio;
  const ColoresScreen({super.key, required this.servicio});
 
  @override
  State<ColoresScreen> createState() => _ColoresScreenState();
}
 
class _ColorOpcion {
  final String nombre;
  final Color color;
  const _ColorOpcion(this.nombre, this.color);
}
 
class _ColoresScreenState extends State<ColoresScreen> {
  static const _paleta = [
    _ColorOpcion('Rojo', Color(0xFFCE2F35)),
    _ColorOpcion('Naranja', Color(0xFFE9A14E)),
    _ColorOpcion('Amarillo', Color(0xFFE7D44C)),
    _ColorOpcion('Café', Color(0xFF6E432C)),
    _ColorOpcion('Rosa', Color(0xFFE96C81)),
    _ColorOpcion('Gris', Color(0xFF5A5A5A)),
    _ColorOpcion('Negro', Color(0xFF0F1118)),
    _ColorOpcion('Turquesa', Color(0xFF5DD5D9)),
  ];
 
  late Future<List<Map<String, dynamic>>> _futurePaquetes;
  int _colorIdx = 0;
  dynamic _paqueteId;
  Map<String, dynamic>? _paqueteSel;
 
  @override
  void initState() {
    super.initState();
    _cargar();
  }
 
  void _cargar() {
    _futurePaquetes = ApiService().obtenerPaquetes(widget.servicio['id']);
  }
 
  String _dinero(dynamic v) {
    final n = num.tryParse(v.toString())?.round() ?? 0;
    final s = n.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return '\$$s';
  }
 
  void _confirmar() {
    Navigator.pop(context, {
      'servicio': widget.servicio,
      'color': _paleta[_colorIdx].nombre,
      'paquete': _paqueteSel,
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final s = widget.servicio;
    final colorSel = _paleta[_colorIdx];
 
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          _cabecera(s),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _vistaPrevia(s, colorSel),
                  const SizedBox(height: 22),
                  const Text(
                    'Elige el color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(_paleta.length, _chipColor),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Elige tu paquete',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Selecciona el alcance del trabajo y continúa con la reserva.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                  ),
                  const SizedBox(height: 12),
                  _listaPaquetes(),
                ],
              ),
            ),
          ),
          _botonContinuar(),
        ],
      ),
    );
  }
 
  Widget _cabecera(Map<String, dynamic> s) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18,
        MediaQuery.of(context).padding.top + 14,
        18,
        22,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF092B4C), Color(0xFF0B5EA7)],
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _botonCircular(
            Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 14),
          _botonCircular(
            (s['icon'] as IconData?) ?? Icons.brush_rounded,
            size: 38,
          ),
          const SizedBox(height: 12),
          Text(
            (s['title'] ?? 'Pintura').toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            (s['subtitle'] ?? 'Calidad Premium').toString(),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
          ),
        ],
      ),
    );
  }
 
  Widget _botonCircular(IconData icon, {VoidCallback? onTap, double size = 38}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
 
  Widget _vistaPrevia(Map<String, dynamic> s, _ColorOpcion c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: c.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
              size: 52,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF101828),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (s['desc'] ?? '').toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF667085),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _chipColor(int i) {
    final c = _paleta[i];
    final sel = i == _colorIdx;
    return GestureDetector(
      onTap: () => setState(() => _colorIdx = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: c.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: sel ? const Color(0xFF1F2937) : Colors.transparent,
            width: sel ? 2.6 : 0,
          ),
        ),
        child: sel
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
 
  Widget _listaPaquetes() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futurePaquetes,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Column(
            children: [
              Text(
                'No se pudieron cargar los paquetes.\n${snap.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
              TextButton(
                onPressed: () => setState(_cargar),
                child: const Text('Reintentar'),
              ),
            ],
          );
        }
        final paquetes = snap.data ?? [];
        if (paquetes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Este servicio aún no tiene paquetes.')),
          );
        }
        return Column(children: paquetes.map(_tarjetaPaquete).toList());
      },
    );
  }
 
  Widget _tarjetaPaquete(Map<String, dynamic> p) {
    final sel = _paqueteId == p['id'];
    final etiqueta = (p['etiqueta'] ?? '').toString();
    final horas = p['duracion_horas'];
 
    return GestureDetector(
      onTap: () => setState(() {
        _paqueteId = p['id'];
        _paqueteSel = p;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sel ? const Color(0xFFE85552) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    (p['nombre'] ?? '').toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: sel
                          ? const Color(0xFFB0233B)
                          : const Color(0xFF1F2937),
                    ),
                  ),
                ),
                if (etiqueta.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      etiqueta,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB0233B),
                      ),
                    ),
                  ),
              ],
            ),
            if ((p['descripcion'] ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                p['descripcion'].toString(),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF667085),
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  horas != null ? '$horas horas' : '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667085),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _dinero(p['precio']),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  Widget _botonContinuar() {
    final habilitado = _paqueteSel != null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: habilitado ? _confirmar : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE85552),
              disabledBackgroundColor: const Color(0xFFE5B5B4),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}