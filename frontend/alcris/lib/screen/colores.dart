import 'package:flutter/material.dart';

class ColoresScreen extends StatefulWidget {
  const ColoresScreen({super.key});

  @override
  State<ColoresScreen> createState() => _ColoresScreenState();
}

class _ColoresScreenState extends State<ColoresScreen> {
  final List<String> _tipos = ['todos', 'Sólido', 'Metálico', 'perlado'];

  final List<_ColorChip> _colores = [
    _ColorChip('Naranja', const Color(0xFFE9A14E)),
    _ColorChip('Rojo', const Color(0xFFCE2F35)),
    _ColorChip('Amarillo', const Color(0xFFE7D44C)),
    _ColorChip('Café', const Color(0xFF6E432C)),
    _ColorChip('brillante', const Color(0xFFE96C81)),
    _ColorChip('mate', const Color(0xFF5A5A5A)),
    _ColorChip('Sólido', const Color(0xFF0F1118)),
    _ColorChip('perla', const Color(0xFF5DD5D9)),
  ];

  String _tipoSeleccionado = 'Sólido';
  String _colorSeleccionado = 'Rojo';
  String _acabadoSeleccionado = 'perlado';

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = _getColorByName(_colorSeleccionado);

    return Scaffold(
      backgroundColor: const Color(0xFF092B4C),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 390,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF092B4C),
                  Color(0xFF0B2D4A),
                  Color(0xFF0F3D6D),
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                  child: Row(
                    children: [
                      _circleButton(Icons.arrow_back_ios_new_rounded, onTap: () {}),
                      const SizedBox(width: 10),
                      _circleButton(Icons.directions_car_filled_rounded, onTap: () {}),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Color del\nvehículo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                height: 1.08,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                                Container(
                                  width: 118,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFCB2E2D), Color(0xFF9D1F25)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.directions_car_filled_rounded,
                                      color: Colors.white.withValues(alpha: 0.96),
                                      size: 62,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Toyota corolla 2018',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF667085),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _colorSeleccionado == 'Rojo'
                                            ? 'Rojo pasión'
                                            : 'Rojo carmesí',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF101828),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Selecciona el color y el acabado\npara continuar con la reserva del servicio.',
                                        style: TextStyle(
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
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: _tipos.map((tipo) {
                              final selected = tipo == _tipoSeleccionado;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _tipoSeleccionado = tipo;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selected ? const Color(0xFF0B5EA7) : const Color(0xFFE8E7E5),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    tipo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: selected ? Colors.white : const Color(0xFF2B2B2B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Paleta de colores',
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
                            children: _colores.map((color) {
                              final isSelected = color.name == _colorSeleccionado;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _colorSeleccionado = color.name;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: color.value,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF1F2937) : Colors.transparent,
                                      width: isSelected ? 2.6 : 0,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: color.value.withValues(alpha: 0.35),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? const Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        )
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Tipo de acabado',
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
                            children: ['brillante', 'mate', 'Sólido', 'perla'].map((acabado) {
                              final isSelected = acabado == _acabadoSeleccionado;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _acabadoSeleccionado = acabado;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 72,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFE7E9EB) : const Color(0xFFF0F0F0),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Text(
                                      acabado,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? const Color(0xFF111827) : const Color(0xFF555555),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F1F1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: selectedColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getColorNameLabel(_colorSeleccionado),
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'PP #RAL-343',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _acabadoSeleccionado,
                                  style: const TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE85552),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'confirmar color',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Color _getColorByName(String name) {
    switch (name) {
      case 'Naranja':
        return const Color(0xFFE9A14E);
      case 'Rojo':
        return const Color(0xFFCE2F35);
      case 'Amarillo':
        return const Color(0xFFE7D44C);
      case 'Café':
        return const Color(0xFF6E432C);
      case 'brillante':
        return const Color(0xFFE96C81);
      case 'mate':
        return const Color(0xFF5A5A5A);
      case 'Sólido':
        return const Color(0xFF0F1118);
      case 'perla':
        return const Color(0xFF5DD5D9);
      default:
        return const Color(0xFFCE2F35);
    }
  }

  String _getColorNameLabel(String name) {
    switch (name) {
      case 'Naranja':
        return 'naranja';
      case 'Rojo':
        return 'rojo carmesí';
      case 'Amarillo':
        return 'amarillo';
      case 'Café':
        return 'café';
      case 'brillante':
        return 'rojo carmesí';
      case 'mate':
        return 'matte';
      case 'Sólido':
        return 'sólido';
      case 'perla':
        return 'perla';
      default:
        return 'rojo carmesí';
    }
  }
}

class _ColorChip {
  final String name;
  final Color value;

  const _ColorChip(this.name, this.value);
}
