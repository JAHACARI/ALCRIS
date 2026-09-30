import 'package:flutter/material.dart';

class ModalEditarPerfil extends StatefulWidget {
  final String nombreInicial;
  final String localidadInicial;
  final Function(String, String) onGuardar;

  const ModalEditarPerfil({
    super.key,
    required this.nombreInicial,
    required this.localidadInicial,
    required this.onGuardar,
  });

  @override
  State<ModalEditarPerfil> createState() => _ModalEditarPerfilState();
}

class _ModalEditarPerfilState extends State<ModalEditarPerfil> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.nombreInicial);
    _locationController = TextEditingController(text: widget.localidadInicial);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24, left: 24, right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24, // Evita que el teclado tape el botón
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Editar Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
            ],
          ),
          const SizedBox(height: 20),
          _buildInput('Nombre de usuario', _nameController, Icons.person_outline_rounded),
          const SizedBox(height: 16),
          _buildInput('Localidad / Ciudad', _locationController, Icons.location_on_outlined),
          const SizedBox(height: 24),
          Container(
            width: double.infinity, height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFE94560), Color(0xFFC0392B)], begin: Alignment.topCenter),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.onGuardar(_nameController.text, _locationController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Guardar Cambios', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(prefixIcon: Icon(icon, size: 20, color: Colors.grey), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ),
      ],
    );
  }
}