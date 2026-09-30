import 'package:flutter/material.dart';
import 'package:alcris/widgets/perfil/editarperfil.dart';

class TarjetaUsuario extends StatefulWidget {
  final String nombre;
  final String eslogan;
  final String localidad;

  const TarjetaUsuario({
    super.key,
    required this.nombre,
    required this.eslogan,
    required this.localidad,
  });

  @override
  State<TarjetaUsuario> createState() => _TarjetaUsuarioState();
}

class _TarjetaUsuarioState extends State<TarjetaUsuario> {
  late String _currentName;
  late String _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentName = widget.nombre;
    _currentLocation = widget.localidad;
  }

  void _abrirEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => ModalEditarPerfil(
        nombreInicial: _currentName,
        localidadInicial: _currentLocation,
        onGuardar: (nuevoNombre, nuevaLocalidad) {
          setState(() {
            if (nuevoNombre.trim().isNotEmpty) _currentName = nuevoNombre;
            if (nuevaLocalidad.trim().isNotEmpty) _currentLocation = nuevaLocalidad;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32, backgroundColor: const Color(0xFFECEFF1),
            child: Text(
              _currentName.isNotEmpty ? _currentName[0].toUpperCase() : 'U',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_currentName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(widget.eslogan, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(_currentLocation, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          // Cambiamos el ícono estático por un botón interactivo de edición con lápiz
          IconButton(
            onPressed: _abrirEditor,
            icon: const Icon(Icons.edit_note_rounded, color: Color(0xFFE94560), size: 28),
          ),
        ],
      ),
    );
  }
}
